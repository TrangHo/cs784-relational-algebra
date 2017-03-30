class CreateRelationAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :relation_attributes do |t|
      t.integer :relation_id
      t.string :name
      t.string :type

      t.timestamps
    end

    add_index :relation_attributes, :relation_id
  end
end
