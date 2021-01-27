class Note < ApplicationRecord
  with_options presence: true do
    validates :title
    validates :text
    validates :plan
  end

  belongs_to :user
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :note_tags, dependent: :destroy
  has_many :tags, through: :note_tags, dependent: :destroy

  # コメントした投稿を取得するための記述
  has_many :commented_users, through: :comments, source: :user

  has_many :favorites, dependent: :destroy

  # いいねした投稿を取得するための記述
  has_many :favorited_users, through: :favorites, source: :user

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      note_id: id,
      visited_id: user_id,
      action: 'favorite'
    )
    notification.save if notification.valid?
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(note_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end

    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、1つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      note_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメント場合は、通知済みとする
    notification.checked = true if notification.visiter_id == notification.visited_id
    notification.save if notification.valid?
  end

  def self.search(search)
    if search != ''
      Note.where('text LIKE(?)', "%#{search}%")
    else
      Note.all
    end
  end
end
