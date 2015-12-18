module Spektrix
  module Events
    # An event instance.
    class Instance
      include Spektrix::Base
      collection_path "instances"

      after_find ->(r) {
        [:start,
         :start_utc,
         :start_selling_at,
         :start_selling_at_utc,
         :stop_selling_at,
         :stop_selling_at_utc
        ].each do |field|
          if r.respond_to?(field)
            r.send(:"#{field}=",DateTime.parse(r.send(
              field)))
          end

        end
      }

      def status
        InstanceStatus.where(instance_id: self.id).first
      end
    end
  end
end