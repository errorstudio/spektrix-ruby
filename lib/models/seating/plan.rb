module Spektrix
  module Seating
    class Plan
      include Spektrix::Base
      collection_path "plans"

      after_find :handle_recursive_plans

      # Plans can have sub-plans, but the sub-plans are in the top-level array. We need to remove them from the top-level array and inject into the subplan node for the given parent plan. Note that sub-plans are recursive.



    end
  end
end