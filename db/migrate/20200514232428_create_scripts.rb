class CreateScripts < ActiveRecord::Migration[6.0]
  def change
    create_table :scripts do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :price
      t.string :author
      t.integer :users
      t.integer :downloads
      t.boolean :official

      t.timestamps
    end
  end
end
