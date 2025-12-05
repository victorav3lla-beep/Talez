class Story < ApplicationRecord
  belongs_to :profile
  has_many :chats

  # Many-to-many relationships
  has_many :story_characters, dependent: :destroy
  has_many :characters, through: :story_characters

  has_many :story_universes, dependent: :destroy
  has_many :universes, through: :story_universes

  has_many :likes, dependent: :destroy
  has_many :liked_by_profiles, through: :likes, source: :profile

  has_many :bookmarks, dependent: :destroy

  has_many_attached :images
end
