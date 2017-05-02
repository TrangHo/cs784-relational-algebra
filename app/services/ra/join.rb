module RA
  class Join < Base
    ATTRS = Base::ATTRS + [:left, :right, :predicate, :l_attribute_relations,
          :l_relation_attributes, :r_attribute_relations, :r_relation_attributes]
    attr_accessor *ATTRS

    include Concerns::PredicateUtility
    extend Concerns::PredicateUtility

    def apply_to(dataset)
      l_dataset = self.left.relation? ? dataset[self.left.name] : self.left.apply_to(dataset)
      r_dataset = self.right.relation? ? dataset[self.right.name] : self.right.apply_to(dataset)

      apply_to_join(l_dataset, r_dataset)
    end

    def apply_to_join(l_dataset, r_dataset)
      result = []
      l_dataset.each do |l_tuple|
        r_dataset.each do |r_tuple|
          selected = true
          self.flattened_predicates.each do |predicate|
            selected = l_tuple[predicate.left] == r_tuple[predicate.right]
            break unless selected
          end
          result << l_tuple.merge(r_tuple) if selected
        end
      end
      result
    end

    def set_relation_attributes(relations)
      self.left.set_relation_attributes(relations)
      self.right.set_relation_attributes(relations)

      self.l_relation_attributes = self.left.relation_attributes
      self.l_attribute_relations = self.left.attribute_relations

      self.r_relation_attributes = self.right.relation_attributes
      self.r_attribute_relations = self.right.attribute_relations

      self.relation_attributes = self.left.relation_attributes.merge(self.right.relation_attributes)
      self.attribute_relations = {}

      self.left.attribute_relations.each { |k, v| self.attribute_relations.update(k => v) }
      self.right.attribute_relations.each do |attr, relation_names|
        if self.attribute_relations.has_key?(attr)
          self.attribute_relations[attr] += relation_names
          self.attribute_relations[attr].uniq
        else
          self.attribute_relations.update(attr => relation_names)
        end
      end
    end

    private
    def self.recursive_parse(ra_exp_json)
      l_relation = RA::Base.recursive_parse(ra_exp_json.delete(:left))
      r_relation = RA::Base.recursive_parse(ra_exp_json.delete(:right))

      obj = new(ra_exp_json.merge(left: l_relation, right: r_relation))
      unless obj.flattened_predicates
        obj.flattened_predicates = []
        shared_attrs = obj.l_attribute_relations.keys & obj.r_attribute_relations.keys
        shared_attrs.each do |shared_attr|
          obj.flattened_predicates << Predicate::JoinEq.new(
            left: shared_attr,
            right: shared_attr,
            type: AND,
            l_relation_name: obj.left.relation? ? obj.left.name : nil,
            r_relation_name: obj.right.relation? ? obj.right.name : nil)
        end
      end

      raise "Error Parsing: JOIN only support AND and EQUAL predicates for now" if nested_predicates?(obj.flattened_predicates)
      obj.flattened_predicates.each do |predicate|
        raise "Error Parsing: JOIN only support AND and EQUAL predicates for now" unless predicate.type == EQ
      end

      obj
    end

    def update_satisfied_samples(samples)
      join_samples = satisfied_samples_of_join
      join_samples.each do |relation_name, data|
        new_samples = samples[relation_name] || []
        new_samples += data
        samples.update(relation_name => new_samples)
      end
      samples
    end

    def satisfied_samples_of_join
      l_samples = self.left.satisfied_samples
      r_samples = self.right.satisfied_samples

      @flattened_predicates.each do |predicate|
        l_samples.each do |l_relation_name, samples|
          samples.each do |l_sample|
            r_relations = self.r_attribute_relations[predicate.right]

            r_relations.each do |r_relation_name|
              r_samples[r_relation_name].each do |r_sample|
                r_sample.update(predicate.right => l_sample[predicate.left])
              end
            end
          end
        end
      end
      result = {}
      (l_samples.keys + r_samples.keys).uniq.each do |relation_name|
        samples = []
        samples += (l_samples[relation_name] || [])
        samples += (r_samples[relation_name] || [])
        result.update(relation_name => samples)
      end

      result
    end
  end
end
