class Story < ApplicationRecord
  belongs_to :profile
  has_many :chats
  has_many :story_characters
  has_one :story_universes
end
