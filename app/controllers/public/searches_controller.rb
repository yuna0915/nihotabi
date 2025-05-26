class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]     # 検索対象（user/post）
    @keyword = params[:keyword] # 検索キーワード

    if @model == "user"
      # ユーザー検索（名前・ふりがな・ニックネーム）
      users = User.where(
        "last_name LIKE :kw OR first_name LIKE :kw OR last_name_kana LIKE :kw OR first_name_kana LIKE :kw OR nickname LIKE :kw",
        kw: "%#{@keyword}%"
      ).where.not(email: "guest@example.com") # ゲストユーザー除外

      # 並び順切替
      @results = case params[:sort]
                 when 'name'
                   users.order(:nickname)             # ニックネーム順
                 else
                   users.order(created_at: :desc)     # 新着順
                 end

      @results = @results.page(params[:page]).per(10)

    elsif @model == "post"
      # 投稿検索（タイトル・本文・場所名・紐づくマスタ情報）
      @results = Post.joins(:location_genre, :prefecture, :visited_month, :visited_time_zone)
                     .where(
                       "posts.title LIKE :kw OR posts.body LIKE :kw OR posts.location_name LIKE :kw OR
                        location_genres.name LIKE :kw OR prefectures.name LIKE :kw OR
                        visited_months.number LIKE :kw OR visited_time_zones.hour LIKE :kw",
                       kw: "%#{@keyword}%"
                     )
                     .sorted(params[:sort])
                     .page(params[:page]).per(10)

    else
      # 万が一不正なmodelパラメータが来た場合、空の結果を返す
      @results = Kaminari.paginate_array([]).page(params[:page])
    end
  end
end
