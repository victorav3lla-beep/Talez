class Character < ApplicationRecord
  has_one_attached :image
  
  belongs_to :profile, optional: true

  has_many :story_characters, dependent: :destroy
  has_many :stories, through: :story_characters
end
