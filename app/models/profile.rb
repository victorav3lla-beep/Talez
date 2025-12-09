class Profile < ApplicationRecord
  belongs_to :user

  has_many :stories, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :universes, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_stories, through: :likes, source: :story

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_stories, through: :bookmarks, source: :story

  has_one_attached :image

  validates :username, presence: true, uniqueness: { scope: :user_id }
end
