module RA
  module Concerns
    module PredicateUtility
      include RA::Constant

      def flatten_predicates(predicate)
        result = []
        case predicate.type
        when AND
          result += flatten_predicates(predicate.left)
          result += flatten_predicates(predicate.right)
        when OR
          left = flatten_predicates(predicate.left)
          right = flatten_predicates(predicate.right)

          result = merge_predicates(result, left)
          result = merge_predicates(result, right)
        else
          result << predicate
        end
        result
      end

      def merge_predicates(origin, predicates)
        if nested_predicates?(predicates)
          origin += predicates
        else
          origin << predicates
        end
      end

      def nested_predicates?(predicates)
        predicates.first.respond_to?(:first)
      end
    end
  end
end
