class Profile < ApplicationRecord
  belongs_to :user
  has_many :stories
  has_many :likes
  has_many :liked_stories, through: :likes, source: :story
end
