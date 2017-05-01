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
      result = @ra_exp.satisfied_samples
      @relations.each do |relation_name, relation_attributes|
        rand(1..3).times do
          result.update(relation_name => []) if result[relation_name].nil?
          result[relation_name] << generate_sample(relation_attributes)
        end
      end
      result
    end
  end
end
