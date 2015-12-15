module Spektrix
  class ResponseParser < ::Faraday::Response::Middleware
    def on_complete(env)
      # body = env[:body].dup
      # body.extend ::DeepSymbolizable
      # # body = body.deep_symbolize {|k| k.downcase.underscore }
      # puts "\n\n" + body.inspect
      # env[:body] = {
      #   data: body[:events],
      #   errors: {},
      #   metadata: {}
      # }

      doc = Nokogiri::XML(env[:body])
      doc.remove_namespaces!
      # data = doc.xpath("//Event").collect do |e|
      #   Hash.from_xml(env[:body]).values.first
      # end

      data = Hash.from_xml(doc.to_s).deep_symbolize {|k| k.underscore.to_sym}
      data = data.values.first.values.flatten
      data.each do |item|
        if item.has_key?(:attribute)
          item[:custom_attributes] = item[:attribute]
          item.delete(:attribute)
        end
      end
      env[:body] = {
        data: data
      }
      puts "\n\n#{env}"

    end
  end
end