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

    def sample_constraints
      constraints = {}
      if self.relation.relation?
        constraints = self.relation.sample_constraints
        predicate_constraints = self.predicate.sample_constraints(self.relation_attributes, self.attribute_relations)
      else
        recursive_apply_to(self.relation.apply_to(dataset))
      end
      constraints
    end

    def satisfied_samples(no_samples = 1)
      no_samples = no_samples * (nested_predicates?(@flattened_predicates) ? @flattened_predicates.size : 1)
      samples = {}
      rand(1..3).times do
        samples = update_satisfied_samples(samples, @flattened_predicates, self)
      end
      samples
    end

    private
    def self.recursive_parse(ra_exp_json)
      relation = ra_exp_json.delete(:relation)
      nested_relation = Base.recursive_parse(relation) if relation.present?

      new(ra_exp_json.merge(relation: nested_relation))
    end

    def update_satisfied_samples(samples, flattened_predicates, ra_exp)
      ra_exp.relation_attributes.each do |relation_name, attrs|
        new_samples = samples[relation_name] || []
        if nested_predicates?(flattened_predicates)
          flattened_predicates.each do |predicates|
            new_samples << satisfied_sample(predicates, relation_name, ra_exp)
          end
        else
          new_samples << satisfied_sample(flattened_predicates, relation_name, ra_exp)
        end
        samples.update(relation_name => new_samples)
      end
      samples
    end

    def satisfied_sample(unnested_predicates, relation_name, ra_exp)
      # TODO: Need to change for Join
      sample = ra_exp.relation.satisfied_samples[relation_name].sample

      unnested_predicates.each do |predicate|
        flag = true
        flag = false unless ra_exp.relation_attributes.has_key?(relation_name)

        if predicate.relation_name
          flag = false unless predicate.relation_name == relation_name
        else
          ### NOTE: if predicates are ambivalent: same attribute name of different
          ### relations but not clearly state, the value of satisfied predicate will
          ### be set to all. Eg of ambivalent: select a == 1 (R join R.b = S.b S) and there
          ### exists R.a, S.a => unambivalent: select R.a == 1 (R join R.b = S.b S)
          flag = false unless ra_exp.attribute_relations[predicate.left].include?(relation_name)
        end

        next unless flag

        predicate.set_value(sample, ra_exp.relation_attributes[relation_name][predicate.left])
      end
      sample
    end
  end
end
