module Spektrix
  module Tickets
    class Band
      include Spektrix::Base
      collection_path "bands"

      def to_s
        self.name
      end
    end
  end
end