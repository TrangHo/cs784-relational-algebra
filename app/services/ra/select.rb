module RA
  class Select < Base
    ATTRS = Base::ATTRS + [:relation, :predicate]
    attr_accessor *ATTRS

    include Concerns::PredicateUtility
    include Concerns::SampleGenerator

    # Apply to basic case only. Eg: select a==1 (R). Not used for nested cases.
    def apply_to(dataset)
      if self.relation.relation?
        relation_name = self.relation.name
        self.predicate.apply_to(dataset[relation_name])
      else
        recursive_apply_to(self.relation.apply_to(dataset))
      end
    end

    # Apply to nested case
    def recursive_apply_to(dataset)
      self.predicate.apply_to(dataset)
    end

    def set_relation_attributes(relations)
      self.relation.set_relation_attributes(relations)
      self.attribute_relations = self.relation.attribute_relations
      self.relation_attributes = self.relation.relation_attributes
    end

    private
    def self.recursive_parse(ra_exp_json)
      relation = ra_exp_json.delete(:relation)
      nested_relation = Base.recursive_parse(relation) if relation.present?

      new(ra_exp_json.merge(relation: nested_relation))
    end

    def update_satisfied_samples(samples)
      if nested_predicates?(@flattened_predicates)
        @flattened_predicates.each do |predicates|
          samples = merge_satisfied_samples(samples, satisfied_sample(predicates))
        end
      else
        samples = merge_satisfied_samples(samples, satisfied_sample(@flattened_predicates))
      end
      samples
    end

    def satisfied_sample(unnested_predicates)
      ### NOTE: This should generate a hash of tuples such that each relation
      ###       has only 1 tuple
      samples = self.relation.satisfied_samples

      unnested_predicates.each do |predicate|
        samples.keys.each do |relation_name|
          sample = samples[relation_name].sample

          flag = true
          flag = false unless self.relation_attributes.has_key?(relation_name)

          if predicate.relation_name
            flag = false unless predicate.relation_name == relation_name
          else
            ### NOTE: if predicates are ambivalent: same attribute name of different
            ### relations but not clearly state, the value of satisfied predicate will
            ### be set to all. Eg of ambivalent: select a == 1 (R join R.b = S.b S) and there
            ### exists R.a, S.a => unambivalent: select R.a == 1 (R join R.b = S.b S)
            flag = false unless sample.keys.include?(predicate.left)
          end

          next unless flag

          old_value = sample[predicate.left]
          predicate.set_value(sample, self.relation_attributes[relation_name][predicate.left])

          update_value_of_same_attr(samples, old_value, sample[predicate.left])
        end
      end
      samples
    end

    def update_value_of_same_attr(relation_samples, old_value, new_value)
      relation_samples.each do |relation_name, samples|
        samples.each do |sample|
          sample.each do |attr, value|
            if self.relation_attributes[relation_name][attr] == type_of_val(new_value) && value == old_value
              sample.update(attr => new_value)
            end
          end
        end
        relation_samples.update(relation_name => samples)
      end
    end
  end
end
