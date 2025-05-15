class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  after_create :create_notification

  def create_notification
    Notification.create!(
      user_id: follower_id,
      notified_user_id: followed_id,
      action: 'follow'
    )
  end
end
