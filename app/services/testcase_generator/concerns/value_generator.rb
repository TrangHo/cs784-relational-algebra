module TestcaseGenerator
  module Concerns
    module ValueGenerator
      include RA::Constant

      def set_value_for_condition(sample, condition)
        if condition.is_a?(String)
          case condition
          when AND
          when OR
            samples <<
          end
        elsif condition.is_a?()
          update_value_for_condition(sample, condition, @relation_attributes)
        end
      end

      def generate_value_for(type)
        case type
        when RelationAttribute::VARCHAR_TYPE
          Faker::Lorem.sentence
        when RelationAttribute::DOUBLE_TYPE
          Faker::Number.decimal(2).to_f
        when RelationAttribute::INT_TYPE
          Faker::Number.number(2).to_i
        end
      end

      def modify_value_for_neq(value, type)
        case type
        when RelationAttribute::VARCHAR_TYPE
          value + " #{ Faker::Lorem.word }"
        when RelationAttribute::DOUBLE_TYPE
          value + Faker::Number.decimal(2).to_f
        when RelationAttribute::INT_TYPE
          value + Faker::Number.number(2).to_i
        end
        value
      end

      def modify_value_for_less(value, type)
        case type
        when RelationAttribute::DOUBLE_TYPE
          value - Faker::Number.decimal(2).to_f
        when RelationAttribute::INT_TYPE
          value - Faker::Number.number(2).to_i
        end
        value
      end

      def modify_value_for_greater(value, type)
        case type
        when RelationAttribute::DOUBLE_TYPE
          value + Faker::Number.decimal(2).to_f
        when RelationAttribute::INT_TYPE
          value + Faker::Number.number(2).to_i
        end
        value
      end

      def update_value_for_condition(sample, condition, relation_attributes)
        case condition.operator
        when EQ
          eval("sample[#{ condition.l_operand }] = #{ condition.r_operand }")
        when NEQ
          sampe[condition.l_operand] = modify_value_for_neq(eval("#{ condition.r_operand }"), relation_attributes[condition.l_operand].attr_type)
        when LESS
          sampe[condition.l_operand] = modify_value_for_less(eval("#{ condition.r_operand }"), relation_attributes[condition.l_operand].attr_type)
        when LEQ
          sampe[condition.l_operand] = [
            eval("#{ condition.r_operand }"),
            modify_value_for_less(eval("#{ condition.r_operand }"), relation_attributes[condition.l_operand].attr_type)
          ].sample
        when GREATER
          sampe[condition.l_operand] = modify_value_for_greater(eval("#{ condition.r_operand }"), relation_attributes[condition.l_operand].attr_type)
        when GEQ
          sampe[condition.l_operand] = [
            eval("#{ condition.r_operand }"),
            modify_value_for_greater(eval("#{ condition.r_operand }"), relation_attributes[condition.l_operand].attr_type)
          ].sample
        end

        sample
      end
    end
  end
end
