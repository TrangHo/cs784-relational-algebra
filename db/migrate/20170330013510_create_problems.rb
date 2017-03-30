class CreateProblems < ActiveRecord::Migration[5.0]
  def change
    create_table :problems do |t|
      t.text :description
      t.boolean :approved, default: false

      t.timestamps
    end

    add_index :problems, :approved
  end
end
