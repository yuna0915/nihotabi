class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # バリデーション
  validates :last_name, :first_name, :prefecture, presence: true
  validates :last_name_kana, :first_name_kana, presence: true,
            format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  validates :nickname, presence: true, length: { maximum: 20 }
  # 電話番号（11桁のみ、半角数字）
  validates :phone_number, presence: true,
  format: { with: /\A\d{11}\z/, message: "は11桁の半角数字で入力してください" }

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_one_attached :image  
  
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
  
end
