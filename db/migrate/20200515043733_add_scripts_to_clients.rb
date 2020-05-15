class AddScriptsToClients < ActiveRecord::Migration[6.0]
  def up
    change_table :scripts do |t|
      t.references :clients, null: true, foreign_key: true
    end
  end

  def down
    remove_column :scripts, :clients_id
  end
end
