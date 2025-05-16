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
      @results = User.where(
        "last_name LIKE :kw OR first_name LIKE :kw OR last_name_kana LIKE :kw OR first_name_kana LIKE :kw OR nickname LIKE :kw",
        kw: "%#{@keyword}%"
      ).page(params[:page]).per(10)

    when "post"
      @results = Post.joins(:prefecture, :visited_month, :visited_time_zone)
                     .where(
                       "posts.title LIKE :kw OR posts.body LIKE :kw OR
                        posts.created_at LIKE :kw OR
                        prefectures.name LIKE :kw OR
                        visited_months.number LIKE :kw OR
                        visited_time_zones.hour LIKE :kw",
                       kw: "%#{@keyword}%"
                     ).page(params[:page]).per(10)

    when "comment"
      @results = Comment.where("body LIKE ?", "%#{@keyword}%")
                        .page(params[:page]).per(10)

    else
      @results = Kaminari.paginate_array([]).page(params[:page]).per(10)
    end
  end
end
