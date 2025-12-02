class Character < ApplicationRecord
  belongs_to :profile, optional: true

  has_many :story_characters, dependent: :destroy
  has_many :stories, through: :story_characters
end
