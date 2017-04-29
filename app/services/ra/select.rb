module RA
  class Select < Base
    ATTRS = [:type, :relation, :predicate]
    attr_accessor *ATTRS
  end
end
