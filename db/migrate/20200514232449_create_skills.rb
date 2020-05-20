class CreateSkills < ActiveRecord::Migration[6.0]
  def up
    create_table :skills do |t|
      t.string :name
      t.string :description
      t.string :wiki_url
      t.string :icon_url

      t.timestamps
    end
  end

  def down
    drop_table :skills
  end
end
