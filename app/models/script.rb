class Script < ApplicationRecord
  belongs_to :client

  has_many :script_skills
  has_many :script_categories
  has_many :skills, through: :script_skills
  has_many :categories, through: :script_categories
end
