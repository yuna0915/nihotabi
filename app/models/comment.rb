class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true

  after_create :create_notification

  private

  def create_notification
    return if post.user == user 

    Notification.create!(
      user_id: user.id,
      notified_user_id: post.user.id,
      post_id: post.id,
      comment_id: id,
      action: 'comment'
    )
  end
end
