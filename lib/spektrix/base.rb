module Spektrix
  # This is a mixin which allows any class to get data from a Spektrix endpoint
  module Base
    def self.included(base)
      # Include Her::Model. Her does most of the heavy lifting.
      base.include Her::Model

      # Extend class methods (below)
      base.extend ClassMethods

      # Use the connection we set up in the configuration.
      base.send(:use_api,->{Spektrix.configuration.connection})
    end

    # Define method_missing here to allow us to inspect the custom attributes on the object and return as normal attributes.
    def method_missing(method, *args, &block)
      if attributes.has_key?(:custom_attributes) && custom_attributes.has_key?(method.to_sym)
        custom_attributes[method.to_sym]
      else
        super
      end
    end

    module ClassMethods
      # Spektrix expects the ID for an entity to be passed as a querystring parameter, as opposed to an instance being on its own url
      # @param id [Integer] the ID you want to find
      # @return [Object] the entity
      def find(id)
        where("#{entity_name}_id" => id).first
      end

      # 'all' needs to have a querystring param
      def all
        where(all: true)
      end

      # Get the entity name; used in other places (like find())
      # @return [String] the entity name
      def entity_name
        self.to_s.demodulize.underscore
      end

      def first
        all.first
      end
    end

  end
end