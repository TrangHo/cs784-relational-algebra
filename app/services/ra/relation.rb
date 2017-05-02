module RA
  class Relation < Base
    ATTRS = Base::ATTRS + [:name]
    attr_accessor *ATTRS

    include Concerns::SampleGenerator

    def set_relation_attributes(relations)
      if relations.present?
        self.attribute_relations = Hash[relations[self.name].keys.zip([[self.name]] * relations[self.name].keys.size)]
        self.relation_attributes = { self.name => relations[self.name] }
      else
        self.attribute_relations = {}
        self.relation_attributes = {}
      end
    end

    def satisfied_samples
      { self.name => [generate_sample(self.relation_attributes[self.name])]}
    end

    private
    def self.recursive_parse(ra_exp_json)
      new(ra_exp_json)
    end
  end
end
