class Post < ApplicationRecord

  # アソシエーション
  belongs_to :user
  belongs_to :prefecture
  belongs_to :visited_month
  belongs_to :visited_time_zone
  belongs_to :location_genre

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many_attached :images

  # バリデーション

  validates :title, :body, :location_name, :address, presence: true
  # 選択式のプルダウン項目には専用のメッセージ表示
  validates :prefecture_id,        presence: { message: "を選択してください" }
  validates :location_genre_id,    presence: { message: "を選択してください" }
  validates :visited_month_id,     presence: { message: "を選択してください" }
  validates :visited_time_zone_id, presence: { message: "を選択してください" }
  # 画像が1〜5枚かどうかをチェック
  validate :max_five_images_on_create, on: :create

  # geocoder（位置情報取得）
  geocoded_by :address  # `address` から緯度経度を取得する

  # address が変更されたときだけ geocode 実行
  after_validation :geocode, if: :address_changed?

  # 外部キー関連のエラーメッセージ重複（prefectureとprefecture_id）を抑制
  after_validation :deduplicate_foreign_key_errors

  # ソート用スコープ

  scope :sorted_by_new, -> { order(created_at: :desc) }   # 新着順

  scope :sorted_by_likes, -> {                            # いいね数が多い順
    left_joins(:favorites)
      .group(:id)
      .order(Arel.sql('COUNT(favorites.id) DESC'))
  }

  scope :sorted_by_comments, -> {                         # コメント数が多い順
    left_joins(:comments)
      .group(:id)
      .order(Arel.sql('COUNT(comments.id) DESC'))
  }

  scope :sorted_by_views, -> {                            # 閲覧数が多い順
    order(view_count: :desc)
  }

  # 指定されたパラメータに応じてソート切替
  scope :sorted, ->(sort_param) {
    case sort_param
    when 'likes'    then sorted_by_likes
    when 'comments' then sorted_by_comments
    when 'views'    then sorted_by_views
    else                 sorted_by_new
    end
  }

  private

  # 作成時の画像枚数バリデーション（0枚・5枚超弾く）
  def max_five_images_on_create
    if images.size == 0
      errors.add(:images, "を1枚以上選択してください")
    elsif images.size > 5
      errors.add(:images, "は5枚までしか選択できません")
    end
  end

  # 外部キーと関連名のエラーが両方出るのを避ける（ユーザーが混乱しないように）
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
