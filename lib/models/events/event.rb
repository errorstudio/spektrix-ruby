module Spektrix
  module Events
    # An event. This hits the events endpoint on Spektrix and returns a collection.
    class Event
      include Spektrix::Base
      collection_path "events"

      after_find -> (r) { r.duration = r.duration.to_i.minutes }

      def instances
        Instance.where(event_id: self.id, all: true).to_a
      end

      def title
        name
      end

    end
  end
end