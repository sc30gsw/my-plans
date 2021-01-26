class Note < ApplicationRecord
  has_one_attached :image
  has_many :note_tags, dependent: :destroy
  has_many :tags, through: :note_tags, dependent: :destroy
  belongs_to :user

  def self.search(search)
    if search != ''
      Note.where('text LIKE(?)', "%#{search}%")
    else
      Note.all
    end
  end
end
