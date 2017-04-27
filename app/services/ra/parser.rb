module RA
  class Parser
    include Constant

    def parse(str)
      str.strip!

      if str[0] == L_PARENTHESIS
        close_index = find_close_parenthesis(str, 0)
        if close_index == str.length - 1
          str = str.slice(1, close_index - 1).strip
          return parse(str)
        else
          return parse_binary(str)
        end
      else
        if UNARY_OPERATORS.include?(str[0])
          return parse_unary(str)
        elsif str.match(/#{BINARY_OPERATORS.join('|')}/)
          return parse_binary(str)
        else
          return RA::Expression.new(operands: [str])
        end
      end
    end

    private
    def find_close_parenthesis(str, start_index)
      nested_count = 1
      i = start_index + 1
      while nested_count > 0 && i < str.length do
        if str[i] == R_PARENTHESIS
          nested_count -= 1
        elsif str[i] == L_PARENTHESIS
          nested_count += 1
        end
        break if nested_count == 0
        i += 1
      end
      return i
    end

    def parse_unary(str)
      ra_exp = RA::Expression.new(operator: str[0])
      str.slice!(0, 1)
      str.strip!
      ra_exp.conditions = get_conditions(str)
      ra_exp.operands << parse(str)

      return ra_exp
    end

    def parse_binary(str)
      ra_exp = RA::Expression.new
      operator_index = str.index(/#{BINARY_OPERATORS.join('|')}/)

      ra_exp.operands << parse(str.slice(0, operator_index - 1).strip)
      ra_exp.operator = str[operator_index]
      str.slice!(0, operator_index + 1)
      str.strip!

      if str.match(/^\s*(?:\()?\s*(\w|\d)+\s*(#{COND_OPERATORS.join('|')})/)
        get_conditions(str)
      end
      ra_exp.operands << parse(str)

      return ra_exp
    end

    def get_conditions(str)
      str.strip!
      conditions = []
      if str[0] == L_PARENTHESIS
        close_parenthesis_index = find_close_parenthesis(str, 0)
        nested = get_conditions(str.slice(1, close_parenthesis_index - 1))
        conditions << nested

        str.slice!(0, close_parenthesis_index + 1)
        str.strip!
      else
        cond_operator_index = str.index(/#{COND_OPERATORS.join('|')}/)
        if COND_OPERATORS.include?(str.slice(cond_operator_index, 2))
          cond_operator = str.slice(cond_operator_index, 2)
        else
          cond_operator = str[cond_operator_index]
        end
        l_operand = str.slice(0, cond_operator_index).strip
        str.slice!(0, cond_operator_index + cond_operator.length)
        str.strip!

        end_r_operand_index = str.index(/\s|\#{L_PARENTHESIS}/)
        end_r_operand_index = str.length unless end_r_operand_index
        r_operand = str.slice(0, end_r_operand_index).strip
        str.slice!(0, end_r_operand_index)
        str.strip!

        conditions << RA::Condition.new(
          operator: cond_operator,
          l_operand: l_operand,
          r_operand: r_operand
        )
      end

      if CONJUNCTION.include?(str[0])
        conditions << str[0]
        str.slice!(0, 1)
        str.strip!
        conditions += get_conditions(str)
      end

      return conditions
    end
  end
end
