class MembersOnlyNotNullableDefaultFalse < ActiveRecord::Migration[6.0]
  def up
    change_column :skills, :members_only, :boolean, null: false, default: false
  end

  def down
    change_column :skills, :members_only, :boolean, null: true
  end
end
