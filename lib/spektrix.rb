require 'her'
require 'nokogiri'
require 'require_all'
require_rel "spektrix/deep_symbolize"
require_rel '.'
class Hash; include DeepSymbolizable; end
module Spektrix
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    self.configuration.configure_connection
  end

  class Configuration
    attr_accessor :client_name,
                  :client_key_path, #your private RSA key
                  :client_cert_path, # the cert signed by Spektrix
                  :api_key, #the key you get from the spektrix interface.
                  :proxy #note that proxying requests with a client cert might break some stuff.

    attr_reader :connection,
                :ssl_options

    def initialize
      @connection ||= Her::API.new
      @user_agent = "Spektrix Ruby client #{Spektrix::VERSION} (http://github.com/errorstudio/spektrix-ruby)"
    end

    def user_agent=(agent)
      @user_agent = agent || @user_agent
    end

    # Return the Configuration object as a hash, with symbols as keys.
    # @return [Hash]
    def to_hash
      Hash[instance_variables.map { |name| [name.to_s.gsub("@","").to_sym, instance_variable_get(name)] } ]
    end

    def configure_connection
      if @client_name.nil? || @client_key_path.nil? || @client_cert_path.nil? || @api_key.nil?
        raise ArgumentError, "You need to configure the Spektrix gem with a client name, private and public keys before making a call to Spektrix"
      end

      @connection_path = "https://api.system.spektrix.com/#{@client_name}/api/v2"
      @ssl_options = {
        :client_cert => OpenSSL::X509::Certificate.new(File.read(@client_cert_path)),
        :client_key => OpenSSL::PKey::RSA.new(File.read(@client_key_path))
      }


      @connection.setup url: @connection_path, ssl: @ssl_options do |c|

        #Api Auth
        c.params[:api_key] = @api_key

        # Request
        c.use Faraday::Request::UrlEncoded

        # Response
        # c.use Spektrix::DebugMiddleware
        c.use Spektrix::ResponseParser


        # Adapter
        c.use Faraday::Adapter::NetHttp
      end
    end
  end
end
