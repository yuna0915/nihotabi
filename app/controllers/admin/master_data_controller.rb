class Admin::MasterDataController < ApplicationController
  before_action :authenticate_admin!

  def index
    @prefectures = Prefecture.order(:id)
    @visited_months = VisitedMonth.order(:id)
    @visited_time_zones = VisitedTimeZone.order(:id)
    @location_genres = LocationGenre.order(:id)
  end
end
