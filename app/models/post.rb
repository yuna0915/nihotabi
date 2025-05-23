class Post < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many_attached :images

  belongs_to :user
  belongs_to :prefecture
  belongs_to :visited_month
  belongs_to :visited_time_zone
  belongs_to :location_genre

  validates :title, :body, :location_name, :address, presence: true
  validates :prefecture_id, presence: { message: "を選択してください" }
  validates :location_genre_id, presence: { message: "を選択してください" }
  validates :visited_month_id, presence: { message: "を選択してください" }
  validates :visited_time_zone_id, presence: { message: "を選択してください" }

  validate :images_must_be_attached

  # --- geocoder設定（教材準拠） ---
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  # 外部キーと関連名が重複してエラーが出る場合に片方を削除
  after_validation :deduplicate_foreign_key_errors

  # 並び替え用スコープ
  scope :sorted_by_new, -> { order(created_at: :desc) }

  scope :sorted_by_likes, -> {
    left_joins(:favorites)
      .group(:id)
      .order(Arel.sql('COUNT(favorites.id) DESC'))
  }

  scope :sorted_by_comments, -> {
    left_joins(:comments)
      .group(:id)
      .order(Arel.sql('COUNT(comments.id) DESC'))
  }

  scope :sorted_by_views, -> {
    order(view_count: :desc)
  }

  scope :sorted, ->(sort_param) {
    case sort_param
    when 'likes'
      sorted_by_likes
    when 'comments'
      sorted_by_comments
    when 'views'
      sorted_by_views
    else
      sorted_by_new
    end
  }

  private

  def images_must_be_attached
    if images.blank?
      errors.add(:images, "を1枚以上選択してください")
    end
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
