module RA
  module Predicate
    class Leq < Base

      def set_value(sample, type)
        sample[self.left] = [
          eval("#{ self.right }"),
          Less.new.set_value(sample, type)
        ].sample
      end

      def apply_to(dataset)
        dataset ||= []
        dataset.select do |tuple|
          tuple[self.left] <= self.right
        end
      end
    end
  end
end
