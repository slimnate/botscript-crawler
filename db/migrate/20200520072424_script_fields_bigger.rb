class ScriptFieldsBigger < ActiveRecord::Migration[6.0]
  def up
    change_column :scripts, :name, :string, limit: 1000
    change_column :scripts, :url, :string, limit: 2500
  end

  def down
    change_column :script, :name, :string
    change_column :script, :url, :string
  end
end
