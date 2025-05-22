class InquiryReply < ApplicationRecord
  belongs_to :inquiry
  belongs_to :admin

  validates :body, presence: true
end
