class DescriptionHtmlBigger < ActiveRecord::Migration[6.0]
  def up
    change_column :scripts, :description_html, :text, limit: 16.megabytes - 1
  end

  def down
    change_column :scripts, :description_html, :text
  end
end
