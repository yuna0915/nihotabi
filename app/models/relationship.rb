class Relationship < ApplicationRecord

  # アソシエーション
  belongs_to :follower, class_name: "User"   # フォローする側（自分）
  belongs_to :followed, class_name: "User"   # フォローされる側（相手）

  # Relationshipが作成された直後に通知を作成
  after_create :create_notification

  def create_notification
    Notification.create!(
      user_id: follower_id,           # フォローしたユーザー
      notified_user_id: followed_id,  # 通知を受け取るユーザー
      action: 'follow'                # 通知の種類
    )
  end
end
