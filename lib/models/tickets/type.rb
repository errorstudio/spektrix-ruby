module Spektrix
  module Tickets
    class Type
      include Spektrix::Base
      collection_path "ticket-types"
    end
  end
end