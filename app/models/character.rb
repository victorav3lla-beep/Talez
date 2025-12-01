class Character < ApplicationRecord
  has_many :stories, through: :story_characters
  has_many :story_characters
end
