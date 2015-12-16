module Spektrix
  module Events
    # An event. This hits the events endpoint on Spektrix and returns a collection.
    class Event
      include Spektrix::Base
      collection_path "events"

      def instances
        Instance.where(event_id: self.id).to_a
      end
    end
  end
end