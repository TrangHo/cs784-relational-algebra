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
          Faker::Lorem.word
        when RelationAttribute::DOUBLE_TYPE
          Faker::Number.decimal(2).to_f
        when RelationAttribute::INT_TYPE
          Faker::Number.number(2).to_i
        end
      end

      def type_of_val(val)
        if val.is_a?(Integer)
          RelationAttribute::INT_TYPE
        elsif val.is_a?(Float)
          RelationAttribute::DOUBLE_TYPE
        elsif val.is_a?(String)
          RelationAttribute::VARCHAR_TYPE
        end
      end
    end
  end
end
