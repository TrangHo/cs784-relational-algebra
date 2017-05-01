module RA
  class Select < Base
    ATTRS = Base::ATTRS + [:relation, :predicate]
    attr_accessor *ATTRS
  end
end
