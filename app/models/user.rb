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
  has_one_attached :image
  has_one_attached :profile_image
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy   # フォロー：自分→相手
  has_many :followings, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy  # フォロワー：相手→自分
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'user_id', dependent: :destroy       # 通知：送った通知（アクティブ）・受け取った通知
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'notified_user_id', dependent: :destroy
  has_many :inquiries, dependent: :destroy                                                                      # 問い合わせ送信者（ユーザー）・返信者（管理者）
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
  GUEST_USER_EMAIL = "guest@example.com"    # ゲストユーザーのメールアドレス（固定）

  def self.guest                            # ゲストユーザー作成 or 再取得
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
  
  def guest_user?                           # 現在のユーザーがゲストかどうか判定
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
  scope :sorted_by_new, -> { order(created_at: :desc) }               # 新着順

  scope :sorted_by_name, -> {
    order(Arel.sql("CONCAT(last_name_kana, first_name_kana) ASC"))    # 名前順
  }

  scope :sorted, -> (sort_param) {                                    # 指定パラメータに応じたソート切替
    case sort_param
    when 'name'
      sorted_by_name
    else
      sorted_by_new
    end
  }

  # フォロー処理用メソッド
  def follow(user)      # フォローする
    active_relationships.create(followed_id: user.id)
  end

  def unfollow(user)    # フォロー解除
    active_relationships.find_by(followed_id: user.id)&.destroy
  end

  def following?(user)  # フォロー中かどうか
    followings.include?(user)
  end
end
