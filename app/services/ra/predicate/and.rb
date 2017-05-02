module RA
  module Predicate
    class And < Base

      def apply_to(dataset)
        dataset ||= []
        left = self.left.apply_to(dataset)
        right = self.right.apply_to(dataset)
        left.select { |tuple| right.include? tuple }
      end
    end
  end
end
