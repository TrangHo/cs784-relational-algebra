module TestcaseGenerator
  class Operator
    include ActiveModel::AttributeMethods

    ATTRS = [:ra_exp, :relations]

    def initialize(ra_exp_json, relations)
      self.ra_exp = RA::Base.parse(ra_exp_json)
      self.relations = relations
    end

    def samples
    end
  end
end
