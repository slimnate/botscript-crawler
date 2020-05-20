class CreateScripts < ActiveRecord::Migration[6.0]
  def up
    create_table :scripts do |t|
      t.string :name
      t.string :author
      t.string :price
      t.string :url
      t.string :icon_url
      t.text :description_text
      t.text :description_html
      t.string :download_url
      t.integer :user_count
      t.integer :download_count
      t.boolean :official

      t.timestamps
    end
  end

  def down
    drop_table :scripts
  end
end
