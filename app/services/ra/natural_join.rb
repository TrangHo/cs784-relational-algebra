module RA
  class NaturalJoin < Base
    ATTRS = Base::ATTRS + [:left, :right]
    attr_accessor *ATTRS

    def apply_to(dataset)
    end

    # Apply to nested case
    def recursive_apply_to(dataset)
    end

    def sample(relations, preset_vals)
      if self.left.relation?
        preset_vals
      else
      end
    end

    private
    def self.recursive_parse(ra_exp_json)
    end
  end
end
