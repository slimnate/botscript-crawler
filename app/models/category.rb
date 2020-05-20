class Category < ApplicationRecord
  has_many :script_categories
  has_many :scripts, through: :script_categories
end
