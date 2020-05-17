class CreateScriptCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :script_categories do |t|
      t.references :script, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
