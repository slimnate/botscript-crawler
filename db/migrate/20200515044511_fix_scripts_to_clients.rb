class FixScriptsToClients < ActiveRecord::Migration[6.0]
  def change
    change_table :scripts do |t|
      t.references :client, null: true, foreign_key: true
    end
  end
end
