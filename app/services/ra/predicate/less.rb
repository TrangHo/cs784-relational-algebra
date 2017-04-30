module RA
  module Predicate
    class Less < Base

      def set_value(sample, type)
        value = sample[self.left] || generate_value_for(type)
        sample[self.left] = case type
                            when RelationAttribute::DOUBLE_TYPE
                              value - Faker::Number.decimal(1).to_f
                            when RelationAttribute::INT_TYPE
                              value - Faker::Number.number(1).to_i
                            end
      end
    end
  end
end
