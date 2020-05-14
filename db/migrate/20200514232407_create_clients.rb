class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :url
      t.string :forum_url
      t.string :apidocs_url

      t.timestamps
    end
  end
end
