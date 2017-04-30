module TestcaseGenerator
  class Select
    include RA::Constant
    include Concerns::ValueGenerator

    def initialize(ra_exp, relations)
      @ra_exp = ra_exp
      @relations = relations.inject({}) do |res, relation|
        attributes = relation.relation_attributes.inject({}) do |res_attr, attr|
          res_attr.update(attr.name => attr.attr_type)
        end
        res.update(relation.name => attributes)
      end
      @relations = HashWithIndifferentAccess.new(@relations)
      @flattened_predicates = flatten_predicates(@ra_exp.predicate)
    end

    def samples
      result = {}
      @relations.each do |relation_name, relation_attributes|
        result[relation_name] = []
        result[relation_name] += generate_samples(relation_name, relation_attributes, true)
        result[relation_name] += generate_samples(relation_name, relation_attributes)
        result[relation_name] += generate_samples(relation_name, relation_attributes)
      end
      result
    end

    private
    def flatten_predicates(predicate)
      result = []
      case predicate.type
      when AND
        result += flatten_predicates(predicate.left)
        result += flatten_predicates(predicate.right)
      when OR
        left = flatten_predicates(predicate.left)
        right = flatten_predicates(predicate.right)

        if nested_predicates?(left)
          result += left
        else
          result << left
        end

        if nested_predicates?(right)
          result += right
        else
          result << right
        end
      else
        result << predicate
      end
      result
    end

    def nested_predicates?(predicates)
      predicates.first.respond_to?(:first)
    end

    def generate_samples(relation_name, relation_attributes, satisfy_conditions = false)
      if satisfy_conditions
        nested = nested_predicates?(@flattened_predicates)
        if nested
          samples = []
          @flattened_predicates.each do |predicates|
            samples << generate_sample_with_predicates(relation_name, relation_attributes, predicates)
          end
          samples
        else
          [generate_sample_with_predicates(relation_name, relation_attributes, @flattened_predicates)]
        end
      else
        [generate_sample(relation_attributes)]
      end
    end

    def generate_sample(relation_attributes)
      sample = {}
      relation_attributes.each do |key, type|
        sample[key] = generate_value_for(type)
      end
      sample
    end

    # TODO: This works only for case: select directly on relation
    def generate_sample_with_predicates(relation_name, relation_attributes, predicates)
      sample = generate_sample(relation_attributes)
      predicates.each do |predicate|
        # NOTE: Assume same relation if predicate has no relation_name
        same_relation = predicate.relation_name ? predicate.relation_name == relation_name : true
        predicate.set_value(sample, relation_attributes[predicate.left]) if same_relation && relation_attributes.has_key?(predicate.left)
      end
      sample
    end
  end
end
