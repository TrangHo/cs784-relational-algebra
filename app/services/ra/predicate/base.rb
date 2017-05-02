module RA
  module Predicate
    class Base
      include RA::Constant
      include ActiveModel::AttributeMethods
      include Concerns::SampleGenerator

      ATTRS = [:left, :right, :type, :relation_name]
      attr_accessor *ATTRS

      def initialize(attributes = {})
        attributes = HashWithIndifferentAccess.new(attributes)
        self.left, self.relation_name = self.class.parse_left(attributes[:left], attributes[:relation_name])
        self.right = attributes[:right]
        self.type = attributes[:type]
      end

      def self.parse(predicate_json, operator)
        predicate_json = HashWithIndifferentAccess.new(predicate_json)
        recursive_parse(predicate_json, operator)
      end

      def nested?
        CONJUNCTION.include? self.type
      end

      private
      def self.recursive_parse(predicate_json, operator)
        relation_name = predicate_json[:relation_name]
        obj = klass_of(predicate_json[:type], operator).new(type: predicate_json[:type])

        if obj.is_a?(RA::Predicate::JoinEq)
          if predicate_json[:left].is_a?(Hash)
            obj.left = recursive_parse(predicate_json[:left].merge(l_relation_name: relation_name), operator)
          else
            obj.left, obj.l_relation_name = parse_left(predicate_json[:left], relation_name)
          end

          if predicate_json[:right].is_a?(Hash)
            obj.right = recursive_parse(predicate_json[:right].merge(r_relation_name: relation_name), operator)
          else
            obj.right, obj.r_relation_name = parse_left(predicate_json[:right], relation_name)
          end
        else
          if predicate_json[:left].is_a?(Hash)
            obj.left = recursive_parse(predicate_json[:left].merge(relation_name: relation_name), operator)
          else
            obj.left, obj.relation_name = parse_left(predicate_json[:left], relation_name)
          end
          obj.right = predicate_json[:right].is_a?(Hash) ? recursive_parse(predicate_json[:right].merge(relation_name: relation_name), operator) : predicate_json[:right]
        end
        obj
      end

      # if case 'select R.a == 1 (S)' => self.relation_name = R instead of S
      def self.parse_left(left, relation_name = nil)
        if left.is_a?(String) && left.match(/\./)
          relation_name, left = left.split('.')
        end
        [left, relation_name]
      end

      def self.klass_of(type, operator)
        case type
        when EQ
          case operator
          when JOIN
            RA::Predicate::JoinEq
          else
            RA::Predicate::Eq
          end
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
