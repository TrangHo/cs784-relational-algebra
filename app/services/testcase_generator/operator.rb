module TestcaseGenerator
  class Operator
    include RA::Constant
    include RA::Concerns::SampleGenerator
    include ActiveModel::AttributeMethods

    ATTRS = [:ra_exp, :relations]

    def initialize(ra_exp_json, relations)
      @relations = relations.inject({}) do |res, relation|
        attributes = relation.relation_attributes.inject({}) do |res_attr, attr|
          res_attr.update(attr.name => attr.attr_type)
        end
        res.update(relation.name => attributes)
      end
      @predicated_relations = {}
      @ra_exp = RA::Base.parse(ra_exp_json, @relations)
    end

    def samples
      result = {}
      result = @ra_exp.satisfied_samples(2)
      ra_exp = @ra_exp
      while !ra_exp.relation? do
        if ra_exp.select?
          ra_exp = ra_exp.relation
        elsif ra_exp.join?
          ra_exp = ra_exp.left
        end
        result = merge_satisfied_samples(result, ra_exp.satisfied_samples)
      end
      @relations.each do |relation_name, relation_attributes|
        rand(1..2).times do
          result.update(relation_name => []) if result[relation_name].nil?
          result[relation_name] << generate_sample(relation_attributes)
        end
      end
      result
    end
  end
end
