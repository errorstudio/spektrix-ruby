module Spektrix
  module Seating
    class Plan
      include Spektrix::Base
      collection_path "plans"

      def to_s
        name
      end

      def all
        @all ||= all(all: true)
      end

      # The API doesn't allow you to filter by band_id, so we get all and find() in ruby
      def self.find(id)
        all.to_a.find {|b| b.id.to_i == id}
      end

    end
  end
end