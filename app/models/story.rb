class Story < ApplicationRecord
  belongs_to :profile
  has_many :chats
  has_many :story_characters
  has_one :story_universes
  has_many :likes
  has_many :liked_by_profiles, through: :likes, source: :profile
end
