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
        result[relation_name] += generate_samples(relation_attributes, true)
        result[relation_name] += generate_samples(relation_attributes)
        result[relation_name] += generate_samples(relation_attributes)
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

    # TODO: This works only for case: select directly on relation
    def generate_samples(relation_attributes, satisfy_conditions = false)
      if satisfy_conditions
        nested = nested_predicates?(@flattened_predicates)
        if nested
          samples = []
          @flattened_predicates.each do |predicates|
            samples << generate_sample_with_predicates(relation_attributes, predicates)
          end
          samples
        else
          [generate_sample_with_predicates(relation_attributes, @flattened_predicates)]
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

    def generate_sample_with_predicates(relation_attributes, predicates)
      sample = generate_sample(relation_attributes)
      predicates.each do |predicate|
        predicate.set_value(sample, @ra_exp.relation.name) if relation_attributes.has_key?(predicate.left)
      end
      sample
    end
  end
end
