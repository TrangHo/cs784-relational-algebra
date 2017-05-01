module TestcaseGenerator
  module Concerns
    module SampleGenerator
      include Concerns::ValueGenerator

      def generate_sample(relation_attributes)
        sample = {}
        relation_attributes.each do |key, type|
          sample[key] = generate_value_for(type)
        end
        sample
      end

      def generate_samples(flattened_predicates, relation_name, relation_attributes, satisfy_conditions = false)
        if satisfy_conditions
          nested = nested_predicates?(flattened_predicates)
          if nested
            samples = []
            flattened_predicates.each do |predicates|
              samples << generate_sample_with_predicates(relation_name, relation_attributes, predicates)
            end
            samples
          else
            [generate_sample_with_predicates(relation_name, relation_attributes, flattened_predicates)]
          end
        else
          [generate_sample(relation_attributes)]
        end
      end

      # TODO: This works only for case: select directly on relation
      def generate_sample_with_predicates(relation_name, relation_attributes, predicates)
        sample = generate_sample(relation_attributes)
        flag = true
        predicates.each do |predicate|
          # NOTE: Assume same relation if predicate has no relation_name
          same_relation = predicate.relation_name ? predicate.relation_name == relation_name : true
          if same_relation && relation_attributes.has_key?(predicate.left)
            predicate.set_value(sample, relation_attributes[predicate.left])
          else
            flag = false
          end
          break unless flag
        end
        flag ? sample : nil
      end
    end
  end
end
