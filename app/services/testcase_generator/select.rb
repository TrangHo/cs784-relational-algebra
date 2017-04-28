module TestcaseGenerator
  class Select
    include Concerns::ValueGenerator

    def initialize(ra_exp, relations)
      @ra_exp = ra_exp
      @relations = relations
    end

    def samples
      result = {}
      @relations.each do |relation|
        result[relation.name] = []
        relation_attributes = relation.relation_attributes.map(&:name).zip(relation.relation_attributes).to_h.symbolize_keys
        result[relation.name] = [
          new_sample(relation_attributes, true),
          new_sample(relation_attributes),
          new_sample(relation_attributes)]
      end
      result
    end

    private
    def new_sample(relation_attributes, satisfy_conditions = false)
      sample = {}
      relation_attributes.each do |key, type|
        sample[key] = generate_value_for(type)
      end

      unless satisfy_conditions
        skip = false
        @ra_exp.conditions.each do |condition|
          if skip
            skip = false
            next
          end
          if condition.is_a?(String)
            skip = true if condition == OR
          else
            set_value_for_condition(sample, condition)
          end
        end
      end

      sample
    end
  end
end
