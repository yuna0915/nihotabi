class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :last_name, :first_name, :prefecture, presence: true
  validates :last_name_kana, :first_name_kana, presence: true,
            format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  validates :nickname, presence: true, length: { maximum: 20 }
  validates :phone_number, presence: true,
            format: { with: /\A\d{11}\z/, message: "は11桁の半角数字で入力してください" }

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one_attached :image  
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post

  # フォロー機能用アソシエーション（編集済）
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  # 通知機能アソシエーション
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'user_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'notified_user_id', dependent: :destroy

  # 問い合わせ機能アソシエーション
  has_many :inquiries, dependent: :destroy            # ユーザーからの問い合わせ一覧
  has_many :inquiry_replies, foreign_key: "admin_id", class_name: "InquiryReply", dependent: :destroy


  # アクティブユーザー判定
  def active_for_authentication?
    super && is_active?
  end
  
  def inactive_message
    is_active? ? super : :inactive_account
  end

  # ゲストログイン用
  GUEST_USER_EMAIL = "guest@example.com"

  def self.guest
    find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.nickname = "ゲスト"
      user.last_name = "ゲスト"
      user.first_name = "ユーザー"
      user.last_name_kana = "ゲスト"
      user.first_name_kana = "ユーザー"
      user.prefecture = "〇〇県" 
      user.introduction = "こんにちは、ゲストユーザーです。"
      user.phone_number = "00000000000"
      user.is_active = true
    end
  end

  def guest_user?
    email == GUEST_USER_EMAIL
  end

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

  # フォロー機能用メソッド
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
