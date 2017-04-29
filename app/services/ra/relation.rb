module RA
  class Relation < Base
    ATTRS = [:type, :name]
    attr_accessor *ATTRS
  end
end
