module RA
  class Relation < Base
    ATTRS = Base::ATTRS + [:name]
    attr_accessor *ATTRS
  end
end
