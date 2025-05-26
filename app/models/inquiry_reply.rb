class InquiryReply < ApplicationRecord
  # 問い合わせ返信は、1つの問い合わせ・1人の管理者に属する
  belongs_to :inquiry
  belongs_to :admin

  validates :body, presence: true

  # 返信作成後に通知を作成
  after_create :create_notification

  private

  def create_notification
    Notification.create!(
      user_id: admin.id,                   # 通知を作成した人（管理者）
      notified_user_id: inquiry.user.id,   # 通知を受け取る人（問い合わせしたユーザー）
      inquiry_id: inquiry.id,              # 関連する問い合わせ
      action: 'inquiry_reply'              # 通知の種類
    )
  end
end
