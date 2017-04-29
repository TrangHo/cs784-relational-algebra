module RAOperators
  class Select < Operator
    ATTRS = Operator::ATTRS + [:conditions]
    attr_accessor *ATTRS

    # conditions has the form:
    # conditions = { type: and/or, predicates: [] }

    #TODO: no OR conjunction yet
    def generate_samples(no_output_tuples = 1, no_unmatched_tuples = 2)
      result = []
      no_output_tuples.times do
        sample = {}
        self.relation_attributes.each do |attr, type|
          sample[attr] =
        end
      end
    end
  end
end
