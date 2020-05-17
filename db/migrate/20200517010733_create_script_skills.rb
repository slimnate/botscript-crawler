class CreateScriptSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :script_skills do |t|
      t.references :script, foreign_key: true
      t.references :skill, foreign_key: true
      
      t.timestamps
    end
  end
end
