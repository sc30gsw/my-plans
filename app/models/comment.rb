class Comment < ApplicationRecord
  validates :text, presence: true, unless: :was_attached?

  has_one_attached :image
  belongs_to :user
  belongs_to :note

  def was_attached?
    image.attached?
  end
end
