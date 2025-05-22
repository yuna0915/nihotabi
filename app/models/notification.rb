class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }

  belongs_to :user, optional: true
  belongs_to :notified_user, class_name: 'User', foreign_key: 'notified_user_id', optional: true
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :notifiable, polymorphic: true, optional: true
  
end
