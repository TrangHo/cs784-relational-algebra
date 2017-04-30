module TestcaseGenerator
  module Concerns
    module ValueGenerator

      def generate_value_for(type)
        case type
        when RelationAttribute::VARCHAR_TYPE
          Faker::Lorem.sentence
        when RelationAttribute::DOUBLE_TYPE
          Faker::Number.decimal(2).to_f
        when RelationAttribute::INT_TYPE
          Faker::Number.number(2).to_i
        end
      end
    end
  end
end
