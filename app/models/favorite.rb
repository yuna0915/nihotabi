class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 同じユーザーが同じ投稿に複数回いいねできないよう制限
  validates :user_id, uniqueness: { scope: :post_id }

  # いいね作成後に通知を生成
  after_create :create_notification

  private

  # 投稿者といいねしたユーザーが異なる場合に通知を作成
  def create_notification
    return if post.user == user  # 自分の投稿には通知を送らない

    Notification.create!(
      user_id: user.id,                   # いいねしたユーザー
      notified_user_id: post.user.id,     # 通知を受け取るユーザー
      post_id: post.id,                   # 関連する投稿
      action: 'favorite'                  # 通知の種類（いいね）
    )
  end
end