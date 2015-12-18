module Spektrix
  module Events
    # An event instance.
    class Instance
      include Spektrix::Base
      collection_path "instances"

      after_find ->(r) do
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
      end

      def status
        InstanceStatus.where(instance_id: self.id).first
      end
    end
  end
end