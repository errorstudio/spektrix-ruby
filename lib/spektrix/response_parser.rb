module Spektrix
  # A custom response parser to handle the XML format returned by Spektrix.
  # We clean up the XML to remove namespaces, then get the collection itself. The XML includes an attribute called 'attribute' which explodes Ruby, so we reassign this to 'custom_attributes', and clean up the key/value pairs so the attribute name is the key and the value is the value.
  class ResponseParser < ::Faraday::Response::Middleware
    def on_complete(env)

      # Parse the XML
      doc = Nokogiri::XML(env[:body])
      doc.remove_namespaces!

      # Hash has DeepSymbolizable mixed in, which goes through the hash fixing up the CamelCase.
      data = Hash.from_xml(doc.to_s).deep_symbolize {|k| k.underscore.to_sym}

      begin
        # Get the array inside the XML. TODO: this is a bit hacky. Should use xpath.
        data = data.values.first.values.flatten
      rescue
        # Rescue with an empty array, for now.
        data = []
      end

      # Traverse the array, fixing up any attributes called 'attribute'
      data.each do |item|
        if item.has_key?(:attribute)
          item[:custom_attributes] = {}
          item[:attribute].each do |attribute_pair|
            next unless attribute_pair.is_a?(Hash)
            key = attribute_pair.values.first.underscore.downcase.parameterize("_").to_sym
            value = attribute_pair.values.last
            value = false if value == "0"
            value = true if value == "1"
            item[:custom_attributes][key] = value
          end

          #Remove the 'attribute' attribute because, y'know.
          item.delete(:attribute)
        end
      end

      # Set up the hash as Her expects.
      env[:body] = {
        data: data
      }
    end
  end
end