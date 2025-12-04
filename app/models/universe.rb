class Universe < ApplicationRecord
  belongs_to :profile, optional: true

  has_many :story_universes, dependent: :destroy
  has_many :stories, through: :story_universes

  has_one_attached :image
end
