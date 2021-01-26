class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:twitter, :facebook]

  with_options presence: true do
    validates :nickname, format: { with: /\A[a-z\d]{4,16}+\z/i, message: 'が4文字以上の半角英数字ではありません' }
    validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,100}+\z/i, message: 'は8文字以上の半角英数字ではありません' }
  end

  has_one :intro
  has_many :sns_credentials
  has_many :note
  has_many :comments
  has_many :favorites, dependent: :destroy
  has_many :relationships

  # コメントした投稿を取得するための記述
  has_many :commented_notes, through: :comments, source: :note
  # いいねした投稿を取得するための記述
  has_many :favorited_notes, through: :favorites, source: :note
  # follow_idを参照してfollowingモデルにアクセス
  has_many :followings, through: :relationships, source: :follow
  # relationモデルのfollow_idを参照してフォローの逆をするための記述
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  # user_idでフォローしてくれているユーザーを取得するための記述
  has_many :followers, through: :reverse_of_relationships, source: :user
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  def self.from_omniauth(auth)
    sns = SnsCredential.where(provider: auth.provider, uid: auth.uid).first_or_create
    # sns認証したことがあればアソシエーションで取得
    # 無ければemailでユーザー検索して取得orビルド(保存はしない)
    user = User.where(email: auth.info.email).first_or_initialize(
      nickname: auth.info.name,
        email: auth.info.email
    )
    # userが登録済みであるか判断
    if user.persisted?
      sns.user = user
      sns.save
    end
    { user: user, sns: sns }
  end

  def self.guest
    find_or_create_by!(nickname: 'guest', email: 'guest@example.com') do |user|
      user.password = 'guest111'
    end
  end

  # 自分をフォローしないようにするため
  def follow(other_user)
    relationships.find_or_create_by(follow_id: other_user.id) unless self == other_user
  end

  # フォローを外せるようにする
  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  # フォローしているか判定
  def following?(other_user)
    followings.include?(other_user)
  end

  # フォロー通知
  def create_notification_follow!(current_user)
    temp = Notification.where(['visiter_id = ? and visited_id = ? and action = ?', current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end