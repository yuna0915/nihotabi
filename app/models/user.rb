class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates :last_name, :first_name, :prefecture, presence: true
  validates :last_name_kana, :first_name_kana, presence: true,
            format: { with: /\A[ァ-ヶー－]+\z/, message: "は全角カタカナで入力してください" }
  validates :nickname, presence: true, length: { maximum: 20 }
  # 電話番号（11桁のみ、半角数字）
  validates :phone_number, presence: true,
  format: { with: /\A\d{11}\z/, message: "は11桁の半角数字で入力してください" }

  has_many :posts, dependent: :destroy
  has_one_attached :image  
  
  def active_for_authentication?
    super && is_active?
  end
  
  def inactive_message
    is_active? ? super : :inactive_account
  end
end
