module Spektrix
  class ResponseParser < ::Faraday::Response::Middleware
    def on_complete(env)

      doc = Nokogiri::XML(env[:body])
      doc.remove_namespaces!

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
    end
  end
end