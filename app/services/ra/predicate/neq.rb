module RA
  module Predicate
    class Neq < Base

      def set_value(sample, type)
        value = sample[self.left] || generate_value_for(type)
        sample[self.left] = case type
                            when RelationAttribute::VARCHAR_TYPE
                              value + " #{ Faker::Lorem.word }"
                            when RelationAttribute::DOUBLE_TYPE
                              value + Faker::Number.decimal(2).to_f
                            when RelationAttribute::INT_TYPE
                              value + Faker::Number.number(2).to_i
                            end
      end

      def apply_to(dataset)
        dataset ||= []
        dataset.select do |tuple|
          tuple[self.left] != eval("#{ self.right }")
        end
      end
    end
  end
end
