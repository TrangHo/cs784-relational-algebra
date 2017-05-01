module TestcaseGenerator
  module Concerns
    module PredicateUtility
      include RA::Constant

      def recursive_unnest_predicates(ra_exp)
        predicates = flatten_predicates(ra_exp.predicate)
        return predicates if ra_exp.relation.relation?

        result = []
        nested_predicates = recursive_unnest_predicates(ra_exp.relation)

        if nested_predicates?(predicates)
          predicates.each do |predicate|
            if nested_predicates?(nested_predicates)
              nested_predicates.each do |nested_predicate|
                result << predicate + nested_predicate
              end
            else
              result << predicate + nested_predicates
            end
          end
        else
          if nested_predicates?(nested_predicates)
            nested_predicates.each do |nested_predicate|
              result << predicates + nested_predicate
            end
          else
            result = predicates + nested_predicates
          end
        end

        result
      end

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
