class Inquiry < ApplicationRecord
  belongs_to :user
  has_many :inquiry_replies, dependent: :destroy

  validates :title, presence: true
  validates :body, presence: true
end
