module Spektrix
  module Events
    # An event instance.
    class Instance
      include Spektrix::Base
      collection_path "instances"

      after_find ->(r) do
        # parse times
        [:start,
         :start_utc,
         :start_selling_at,
         :start_selling_at_utc,
         :stop_selling_at,
         :stop_selling_at_utc
        ].each do |field|
          if r.respond_to?(field)
            time = Time.parse(r.send(field))
            if field.to_s =~ /_utc$/
              time = time.in_time_zone('UTC')
            else
              time = time.in_time_zone('London')
            end

            r.send(:"#{field}=",time)
          end
        end

        # we make price_list an actual Spektrix::Tickets:PriceList, but keep the original for reference
        r.price_list_id = r.price_list[:id].to_i

      end

      def status
        InstanceStatus.where(instance_id: self.id).first
      end

      def price_list_object
        Tickets::PriceList.where(instance_id: self.id).first
      end

      def event_object
        Event.where(event_id: event[:id]).first
      end

    end
  end
end