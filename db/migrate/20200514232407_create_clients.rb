class CreateClients < ActiveRecord::Migration[6.0]
  def up
    create_table :clients do |t|
      t.string :name
      t.string :url
      t.string :icon_url
      t.string :forum_url
      t.string :apidocs_url
      t.string :download_url

      t.timestamps
    end
  end

  def down
    drop_table :clients
  end
end
