class Skill < ApplicationRecord
  has_many :script_skills
  has_many :scripts, through: :script_skills
end
