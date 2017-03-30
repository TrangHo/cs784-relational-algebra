class CreateRelations < ActiveRecord::Migration[5.0]
  def change
    create_table :relations do |t|
      t.integer :problem_id
      t.string :name
      t.jsonb :attrs, default: {}

      t.timestamps
    end

    add_index :relations, [:problem_id, :name]
  end
end
