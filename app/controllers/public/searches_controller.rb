class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @keyword = params[:keyword]

    if @model == "user"
      users = User.where(
        "last_name LIKE :kw OR first_name LIKE :kw OR last_name_kana LIKE :kw OR first_name_kana LIKE :kw OR nickname LIKE :kw",
        kw: "%#{@keyword}%"
      ).where.not(email: "guest@example.com")

      @results = case params[:sort]
                 when 'name'
                   users.order(:nickname)
                 else
                   users.order(created_at: :desc)
                 end

      @results = @results.page(params[:page]).per(10)

    elsif @model == "post"
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
      @results = Kaminari.paginate_array([]).page(params[:page])
    end
  end
end
