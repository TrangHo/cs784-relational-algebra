module TestcaseGenerator
  class Operator
    include ActiveModel::AttributeMethods

    ATTRS = [:ra_exp, :relations]

    def initialize(attributes)
      attributes = HashWithIndifferentAccess.new(attributes)
      self.ra_exp = attributes[:ra_exp]
      self.relations = attributes[:relations]
    end

    def samples
    end
  end
end
