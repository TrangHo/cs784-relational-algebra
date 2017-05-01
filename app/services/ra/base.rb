module RA
  class Base
    include Constant
    include ActiveModel::AttributeMethods

    ATTRS = [:type]
    attr_accessor *ATTRS

    def initialize(attributes = {})
      attributes = HashWithIndifferentAccess.new(attributes)
      self.class::ATTRS.each do |attr|
        self.send("#{attr}=", attributes[attr])
      end
      if attributes[:predicate].present?
        attributes[:predicate].update(relation_name: self.relation.name) if self.relation && self.relation.relation?
        self.predicate = RA::Predicate::Base.parse(attributes[:predicate])
      end
    end

    def self.parse(ra_exp_json)
      ra_exp_json = JSON(ra_exp_json) if ra_exp_json.is_a?(String)
      ra_exp_json = HashWithIndifferentAccess.new(ra_exp_json)
      recursive_parse(ra_exp_json)
    end

    def relation?
      type == RELATION
    end

    private
    def self.recursive_parse(ra_exp_json)
      relation = ra_exp_json.delete(:relation)
      nested_relation = recursive_parse(relation) if relation.present?

      obj = klass_of(ra_exp_json[:type]).new(ra_exp_json.merge(relation: nested_relation))
      obj
    end

    def self.klass_of(type)
      case type
      when RELATION
        RA::Relation
      when SELECT
        RA::Select
      end
    end
  end
end
