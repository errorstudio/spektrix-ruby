module Spektrix
  module Tickets
    class PriceList
      include Spektrix::Base
      collection_path "price-lists"

      after_find ->(r) do
        bands = Band.all.to_a
        ticket_types = Type.all.to_a
        if r.respond_to?(:price)
          r.prices = r.price.collect do |price|
            price[:band] = bands.find {|b| b.id == price[:band][:id]}
            price[:ticket_type] = ticket_types.find {|t| t.id == price[:ticket_type][:id]}
            Price.new(price)
          end
        end
      end
    end
  end
end