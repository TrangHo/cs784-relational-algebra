module RA
  class Select < Base
    ATTRS = Base::ATTRS + [:relation, :predicate]
    attr_accessor *ATTRS

    # Apply to basic case only. Eg: select a==1 (R). Not used for nested cases.
    def apply_to(dataset)
      super do
        relation_name = self.relation.name
        return self.predicate.apply_to(dataset[relation_name])
      end
    end

    # Apply to nested case
    def recursive_apply_to(dataset)
      self.predicate.apply_to(dataset)
    end
  end
end
