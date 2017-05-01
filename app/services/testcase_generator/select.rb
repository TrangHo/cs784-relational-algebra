module TestcaseGenerator
  class Select
    include RA::Constant
    include Concerns::PredicateUtility

    # ra_exp is instance of RA::Relation
    # relations is in the form of { relation_name => { attr_name => attr_type } }
    def initialize(ra_exp)
      @ra_exp = ra_exp
      @flattened_predicates = flatten_predicates(@ra_exp.predicate)
    end

    def flattened_predicates
      @flattened_predicates
    end
  end
end
