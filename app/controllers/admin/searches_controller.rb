class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @model = params[:model]
    @keyword = params[:keyword]

    if @keyword.blank?
      @results = Kaminari.paginate_array([]).page(params[:page]).per(10)
      return
    end

    case @model
    when "user"
      users = User.where(
        "last_name LIKE :kw OR first_name LIKE :kw OR last_name_kana LIKE :kw OR first_name_kana LIKE :kw OR nickname LIKE :kw",
        kw: "%#{@keyword}%"
      )

      @results = case params[:sort]
                 when 'name'
                   users.order(:last_name, :first_name)  # セイ → メイ順
                 else
                   users.order(created_at: :desc)
                 end

    when "post"
      posts = Post.joins(:prefecture, :visited_month, :visited_time_zone)
                  .where(
                    "posts.title LIKE :kw OR posts.body LIKE :kw OR
                     posts.created_at LIKE :kw OR
                     prefectures.name LIKE :kw OR
                     visited_months.number LIKE :kw OR
                     visited_time_zones.hour LIKE :kw",
                    kw: "%#{@keyword}%"
                  )

      @results = case params[:sort]
                 when 'title'
                   posts.order(:title)  # 投稿タイトル順
                 else
                   posts.order(created_at: :desc)
                 end

    when "comment"
      comments = Comment.joins(:user)
                        .where("comments.body LIKE :kw OR users.last_name LIKE :kw OR users.first_name LIKE :kw", kw: "%#{@keyword}%")

      @results = case params[:sort]
                 when 'aiueo'  # ← ここを修正（旧: 'kana'）
                   comments.order(:body)  # ← コメント本文のあいうえお順（シンプル）
                 else
                   comments.order(created_at: :desc)
                 end

    else
      @results = Kaminari.paginate_array([]) # 万が一modelが不正な値でも空配列
    end

    @results = @results.page(params[:page]).per(10)
  end
end
