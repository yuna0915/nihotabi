class Public::PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
    redirect_to users_my_page_path
    else
    render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :location_name,
      :address,
      :place_id,
      :latitude,
      :longitude,
      :image,
      :prefecture_id,
      :visited_month_id,
      :visited_hour_id,
      :location_genre_id
    )
  end

end
