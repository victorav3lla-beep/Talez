class Page < ApplicationRecord
  belongs_to :story
  has_one_attached :image
end
