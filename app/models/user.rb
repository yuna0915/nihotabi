class User < ApplicationRecord

  # ログイン・新規登録
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :last_name, :first_name, presence: true
  validates :prefecture_id, presence: { message: "を選択してください" }
  validates :last_name_kana, :first_name_kana, presence: true,
            format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  validates :nickname, presence: true, length: { maximum: 20 }
  validates :phone_number, presence: true,
            format: { with: /\A\d{11}\z/, message: "は11桁の半角数字で入力してください" }

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'user_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'notified_user_id', dependent: :destroy
  has_many :inquiries, dependent: :destroy
  has_many :inquiry_replies, foreign_key: "admin_id", class_name: "InquiryReply", dependent: :destroy
  belongs_to :prefecture, optional: true

  # アクティブ状態（退会済みならログイン不可）
  def active_for_authentication?
    super && is_active?
  end

  # ログインできないときのメッセージ（退会者に専用メッセージを返す）
  def inactive_message
    is_active? ? super : :inactive_account
  end

  # ゲストログイン用処理
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.nickname = "ゲスト"
      user.last_name = "ゲスト"
      user.first_name = "ユーザー"
      user.last_name_kana = "ゲスト"
      user.first_name_kana = "ユーザー"
      user.prefecture_id = 13
      user.introduction = "こんにちは、ゲストユーザーです。"
      user.phone_number = "00000000000"
      user.is_active = true
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

  # プロフィール画像取得（デフォルト画像も設定）
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(
        io: File.open(file_path),
        filename: 'no_image.jpg',
        content_type: 'image/jpeg'
      )
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  # 並び替えスコープ
  scope :sorted_by_new, -> { order(created_at: :desc) }
  scope :sorted_by_name, -> {
    order(Arel.sql("CONCAT(last_name_kana, first_name_kana) ASC"))
  }
  scope :sorted, -> (sort_param) {
    case sort_param
    when 'name'
      sorted_by_name
    else
      sorted_by_new
    end
  }

  # フォロー処理
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_relationships.find_by(followed_id: user.id)&.destroy
  end

  def following?(user)
    followings.include?(user)
  end
end
