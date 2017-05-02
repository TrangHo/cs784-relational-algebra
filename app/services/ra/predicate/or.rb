module RA
  module Predicate
    class Or < Base

      def apply_to(dataset)
        dataset ||= []
        self.left.apply_to(dataset) + self.right.apply_to(dataset)
      end
    end
  end
end
