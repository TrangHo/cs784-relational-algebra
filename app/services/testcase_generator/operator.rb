module TestcaseGenerator
  class Operator
    include RA::Constant
    include ActiveModel::AttributeMethods
    include Concerns::PredicateUtility
    include Concerns::SampleGenerator

    ATTRS = [:ra_exp, :relations]

    def initialize(ra_exp_json, relations)
      @relations = relations.inject({}) do |res, relation|
        attributes = relation.relation_attributes.inject({}) do |res_attr, attr|
          res_attr.update(attr.name => attr.attr_type)
        end
        res.update(relation.name => attributes)
      end
      @predicated_relations = {}
      @ra_exp = RA::Base.parse(ra_exp_json)
      @flattened_predicates = recursive_unnest_predicates(@ra_exp)
    end

    def flattened_predicates
      @flattened_predicates
    end

    def samples
      result = {}
      @relations.each do |relation_name, relation_attributes|
        result[relation_name] = []
        result[relation_name] += generate_samples(@flattened_predicates, relation_name, relation_attributes, true)
        result[relation_name] += generate_samples(@flattened_predicates, relation_name, relation_attributes)
        result[relation_name] += generate_samples(@flattened_predicates, relation_name, relation_attributes)
        result[relation_name].compact!
      end
      result
    end

    private
    def recursive_unnest_predicates(ra_exp)
      result = []
      if ra_exp.relation.relation?
        generator = generator_of(ra_exp)
        result = generator.flattened_predicates
      else
        generator = generator_of(ra_exp)
        predicates = generator.flattened_predicates
        nested_predicates = recursive_unnest_predicates(ra_exp.relation)

        if nested_predicates?(predicates)
          predicates.each do |predicate|
            if nested_predicates?(nested_predicates)
              nested_predicates.each do |nested_predicate|
                result << predicate + nested_predicate
              end
            else
              result << predicate + nested_predicates
            end
          end
        else
          if nested_predicates?(nested_predicates)
            nested_predicates.each do |nested_predicate|
              result << predicates + nested_predicate
            end
          else
            result = predicates + nested_predicates
          end
        end
      end
      result
    end

    def generator_of(ra_exp)
      case ra_exp.type
      when SELECT
        TestcaseGenerator::Select.new(ra_exp)
      end
    end
  end
end
