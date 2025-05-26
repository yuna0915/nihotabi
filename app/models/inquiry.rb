class Inquiry < ApplicationRecord
  # 問い合わせはユーザーに属し、複数の返信を持つ
  belongs_to :user
  has_many :inquiry_replies
  
  # 件名と内容は必須
  validates :title, presence: true
  validates :body, presence: true
end
