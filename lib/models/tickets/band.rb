module Spektrix
  module Tickets
    class Band
      include Spektrix::Base
      collection_path "bands"

      def to_s
        self.name
      end

      # The API doesn't allow you to filter by band_id, so we get all and find() in ruby
      def self.find(id)
        all.to_a.find {|b| b.id.to_i == id}
      end
    end
  end
end