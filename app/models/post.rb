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

  validate :max_five_images_on_create, on: :create

  # --- geocoder設定 ---
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  after_validation :deduplicate_foreign_key_errors

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
    when 'likes' then sorted_by_likes
    when 'comments' then sorted_by_comments
    when 'views' then sorted_by_views
    else sorted_by_new
    end
  }

  private

  def max_five_images_on_create
    if images.size == 0
      errors.add(:images, "を1枚以上選択してください")
    elsif images.size > 5
      errors.add(:images, "は5枚までしか選択できません")
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
