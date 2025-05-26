class Admin::SearchesController < ApplicationController
  before_action :authenticate_admin!

  def search
    @model = params[:model]     # 検索対象（user/post/comment）
    @keyword = params[:keyword] # キーワード

    if @keyword.blank?
      # キーワード未入力時は空結果を返す
      @results = Kaminari.paginate_array([]).page(params[:page]).per(10)
      return
    end

    case @model
    when "user"
      # ユーザー検索（名前・ふりがな・ニックネーム）
      users = User.where(
        "last_name LIKE :kw OR first_name LIKE :kw OR last_name_kana LIKE :kw OR first_name_kana LIKE :kw OR nickname LIKE :kw",
        kw: "%#{@keyword}%"
      )

      @results = case params[:sort]
                 when 'name'
                   users.order(:last_name, :first_name)  # 姓→名
                 else
                   users.order(created_at: :desc)        # 新着順
                 end

    when "post"
      # 投稿検索（タイトル・本文・日時・紐づくマスタ名）
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
                   posts.order(:title)              # タイトル順
                 else
                   posts.order(created_at: :desc)   # 新着順
                 end

    when "comment"
      # コメント検索（本文＋コメント投稿者の名前）
      comments = Comment.joins(:user)
                        .where("comments.body LIKE :kw OR users.last_name LIKE :kw OR users.first_name LIKE :kw OR users.nickname LIKE :kw", kw: "%#{@keyword}%")

      @results = case params[:sort]
                 when 'aiueo'
                   comments.order(:body)               # コメント本文あいうえお順
                 else
                   comments.order(created_at: :desc)   # 新着順
                 end

    else
      # 不正なモデルが来たときの保険
      @results = Kaminari.paginate_array([])
    end

    @results = @results.page(params[:page]).per(10)
  end
end