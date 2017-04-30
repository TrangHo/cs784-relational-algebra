module RA
  module Predicate
    class Base
      include RA::Constant
      include ActiveModel::AttributeMethods
      include TestcaseGenerator::Concerns::ValueGenerator

      ATTRS = [:left, :right, :type]
      attr_accessor *ATTRS

      def initialize(attributes = {})
        attributes = HashWithIndifferentAccess.new(attributes)
        self.class::ATTRS.each do |attr|
          self.send("#{attr}=", attributes[attr])
        end
      end

      def self.parse(predicate_json)
        predicate_json = HashWithIndifferentAccess.new(predicate_json)
        recursive_parse(predicate_json)
      end

      private
      def self.recursive_parse(predicate_json)
        obj = klass_of(predicate_json[:type]).new(type: predicate_json[:type])
        obj.left = predicate_json[:left].is_a?(Hash) ? recursive_parse(predicate_json[:left]) : predicate_json[:left]
        obj.right = predicate_json[:right].is_a?(Hash) ? recursive_parse(predicate_json[:right]) : predicate_json[:right]
        obj
      end

      def self.klass_of(type)
        case type
        when EQ
          RA::Predicate::Eq
        when NEQ
          RA::Predicate::Neq
        when LESS
          RA::Predicate::Less
        when LEQ
          RA::Predicate::Leq
        when GREATER
          RA::Predicate::Greater
        when GEQ
          RA::Predicate::Geq
        when AND
          RA::Predicate::And
        when OR
          RA::Predicate::Or
        end
      end
    end
  end
end
