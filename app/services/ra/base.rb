module RA
  class Base
    include Constant
    include ActiveModel::AttributeMethods

    ATTRS = [:type, :attribute_relations, :relation_attributes]
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
        self.predicate = RA::Predicate::Base.parse(attributes[:predicate])
        @flattened_predicates = flatten_predicates(self.predicate)
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

    def apply_to(dataset)
      if select? && self.relation.relation?
        yield
      else
        recursive_apply_to(self.relation.apply_to(dataset))
      end
    end

    private
    def self.recursive_parse(ra_exp_json)
      klass_of(ra_exp_json[:type], ra_exp_json[:predicate]).recursive_parse(ra_exp_json)
    end

    def self.klass_of(type, predicate = nil)
      case type
      when RELATION
        RA::Relation
      when SELECT
        RA::Select
      when JOIN
        predicate ? RA::Join : RA::NaturalJoin
      end
    end
  end
end
