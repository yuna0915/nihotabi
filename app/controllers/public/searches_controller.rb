class Public::SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @model = params[:model]
    @keyword = params[:keyword]

    if @model == "user"
      @results = User.where(
        "last_name LIKE :kw OR first_name LIKE :kw OR last_name_kana LIKE :kw OR first_name_kana LIKE :kw OR nickname LIKE :kw",
        kw: "%#{@keyword}%"
      )
    elsif @model == "post"
      @results = Post.joins(:location_genre, :prefecture, :visited_month, :visited_time_zone)
        .where(
          "posts.title LIKE :kw OR posts.body LIKE :kw OR posts.location_name LIKE :kw OR
           location_genres.name LIKE :kw OR prefectures.name LIKE :kw OR
           visited_months.number LIKE :kw OR visited_time_zones.hour LIKE :kw",
          kw: "%#{@keyword}%"
        )
    else
      @results = []
    end
  end
end
