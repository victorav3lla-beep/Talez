class Universe < ApplicationRecord
  has_many :stories, through: :story_universes
  has_many :story_universes
end
