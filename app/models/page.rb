class Page < ApplicationRecord
  belongs_to :story
  has_one_attached :image

  validates :content, presence: { message: "Please describe what happens next" }
end
