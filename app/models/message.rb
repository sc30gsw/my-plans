class Message < ApplicationRecord
  validates :text, presence: true
  belongs_to :user
  belongs_to :room
end
