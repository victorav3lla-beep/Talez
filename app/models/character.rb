class Character < ApplicationRecord
  belongs_to :profile, optional: true

  has_many :story_characters, dependent: :destroy
  has_many :stories, through: :story_characters

  scope :for_profile, ->(profile) {
    where(profile_id: [nil, profile&.id])
  }
end
