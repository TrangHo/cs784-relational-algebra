class RenameTypeOfRelationAttribute < ActiveRecord::Migration[5.0]
  def change
    rename_column :relation_attributes, :type, :attr_type
  end
end
