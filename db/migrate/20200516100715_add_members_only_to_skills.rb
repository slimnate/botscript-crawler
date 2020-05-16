class AddMembersOnlyToSkills < ActiveRecord::Migration[6.0]
  def up
    add_column :skills, :members_only, :boolean
  end

  def down
    remove_column :skills, :members_only
  end
end
