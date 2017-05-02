module RA
  class Base
    include Constant
    include ActiveModel::AttributeMethods

    ATTRS = [:type, :attribute_relations, :relation_attributes, :flattened_predicates]
    attr_accessor *ATTRS

    def initialize(attributes = {})
      attributes = HashWithIndifferentAccess.new(attributes)
      self.class::ATTRS.each do |attr|
        self.send("#{attr}=", attributes[attr])
      end
      if attributes[:predicate].present?
        if select? && self.relation && self.relation.relation?
          attributes[:predicate].update(relation_name: self.relation.name)
        end
        self.predicate = RA::Predicate::Base.parse(attributes[:predicate], attributes[:type])
        self.flattened_predicates = flatten_predicates(self.predicate)
      end
    end

    def self.parse(ra_exp_json, relations = {})
      ra_exp_json = JSON(ra_exp_json) if ra_exp_json.is_a?(String)
      ra_exp_json = HashWithIndifferentAccess.new(ra_exp_json)
      ra_exp = recursive_parse(ra_exp_json)
      ra_exp.set_relation_attributes(relations)
      ra_exp
    end

    def relation?
      type == RELATION
    end

    def select?
      type == SELECT
    end

    def join?
      type == JOIN
    end

    ### Defined in subclasses
    def apply_to(dataset)
      dataset
    end

    def satisfied_samples(max = 1)
      samples = {}
      rand(1..max).times do
        samples = update_satisfied_samples(samples)
      end
      samples
    end

    private
    def self.recursive_parse(ra_exp_json)
      klass_of(ra_exp_json[:type]).recursive_parse(ra_exp_json)
    end

    def update_satisfied_samples(samples)
      ### Defined in subclasses
    end

    def self.klass_of(type)
      case type
      when RELATION
        RA::Relation
      when SELECT
        RA::Select
      when JOIN
        RA::Join
      end
    end
  end
end
