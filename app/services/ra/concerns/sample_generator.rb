module RA
  module Concerns
    module SampleGenerator

      def generate_sample(relation_attributes)
        sample = {}
        relation_attributes.each do |key, type|
          sample[key] = generate_value_for(type)
        end
        sample
      end

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
