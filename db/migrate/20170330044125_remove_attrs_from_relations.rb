class RemoveAttrsFromRelations < ActiveRecord::Migration[5.0]
  def up
    remove_column :relations, :attrs
  end

  def down
    add_column :relations, :attrs, :jsonb, default: {}
  end
end
