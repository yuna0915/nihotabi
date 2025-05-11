class Post < ApplicationRecord
  has_one_attached :image

  has_many :comments, dependent: :destroy
  belongs_to :user
  belongs_to :prefecture
  belongs_to :visited_month
  belongs_to :visited_time_zone
  belongs_to :location_genre

  validates :title, :body, :location_name, :address, presence: true
  validates :prefecture_id, presence: true
  validates :location_genre_id, presence: true
  validates :visited_month_id, presence: true
  validates :visited_time_zone_id, presence: true

  validate :image_must_be_attached

  # 外部キーと関連名が重複してエラーが出る場合に片方を削除
  after_validation :deduplicate_foreign_key_errors

  def get_post_image(width, height)
    image.variant(resize_to_fill: [width, height]).processed
  end

  private

  def image_must_be_attached
    errors.add(:image, "を選択してください") unless image.attached?
  end

  def deduplicate_foreign_key_errors
    {
      prefecture: :prefecture_id,
      visited_month: :visited_month_id,
      visited_time_zone: :visited_time_zone_id,
      location_genre: :location_genre_id
    }.each do |association, foreign_key|
      if errors.added?(association, :blank) && errors.added?(foreign_key, :blank)
        errors.delete(association)
      end
    end
  end
end
