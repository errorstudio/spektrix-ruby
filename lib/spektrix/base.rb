module Spektrix
  module Base
    def self.included(base)
      base.include Her::Model
      base.extend ClassMethods
      base.send(:use_api,->{Spektrix.configuration.connection})
    end

    module ClassMethods

    end

  end
end