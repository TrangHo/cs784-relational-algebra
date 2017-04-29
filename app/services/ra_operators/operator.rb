module RAOperators
  include Concerns::Constant

  class Operator
    include ActiveModel::AttributeMethods

    ATTRS = [:relation_attributes]

    def initialize(attributes = {})
      attributes = HashWithIndifferentAccess.new(attributes)
      self.class::ATTRS.each do |attr|
        self.send("#{attr}=", attributes[attr])
      end
    end
  end
end
