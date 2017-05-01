module RA
  module Predicate
    class Less < Base

      def set_value(sample, type)
        sample[self.left] = case type
                            when RelationAttribute::DOUBLE_TYPE
                              self.right - Faker::Number.decimal(1).to_f
                            when RelationAttribute::INT_TYPE
                              self.right - Faker::Number.number(1).to_i
                            end
      end

      def apply_to(dataset)
        dataset.select do |tuple|
          tuple[self.left] < self.right
        end
      end
    end
  end
end
