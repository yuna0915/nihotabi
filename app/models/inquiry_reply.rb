class InquiryReply < ApplicationRecord
  # 問い合わせ返信は、1つの問い合わせ・1人の管理者に属する
  belongs_to :inquiry
  belongs_to :admin

  validates :body, presence: true
end
