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
      self.predicate = RA::Predicate::Base.parse(attributes[:predicate]) if attributes[:predicate].present?
    end

    def self.parse(ra_exp_json)
      ra_exp_json = HashWithIndifferentAccess.new(ra_exp_json)
      recursive_parse(ra_exp_json)
    end

    private
    def self.recursive_parse(ra_exp_json)
      relation = ra_exp_json.delete(:relation)
      obj = klass_of(ra_exp_json[:type]).new(ra_exp_json)
      obj.relation = recursive_parse(relation) if relation.present?
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
