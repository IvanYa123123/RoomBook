class HotelsController < ApplicationController
  def index
    @city       = params[:city].to_s.strip
    @check_in   = parse_date(params[:check_in])
    @check_out  = parse_date(params[:check_out])
    @guests     = params[:guests].presence&.to_i
    @min_price  = params[:min_price].presence&.to_d
    @max_price  = params[:max_price].presence&.to_d

    scope = Hotel.includes(:rooms, :reviews, photos_attachments: :blob).order(created_at: :desc)
    scope = scope.in_city(@city)
                 .with_capacity(@guests)
                 .with_price_between(@min_price, @max_price)
                 .available_between(@check_in, @check_out)

    @hotels = scope.page(params[:page]).per(9)
    @hotels = @hotels.page(1) if @hotels.current_page > @hotels.total_pages && @hotels.total_pages.positive?
  end

  def show
    @hotel   = Hotel.with_attached_photos.includes(:rooms, reviews: :user).find(params[:id])
    @reviews = @hotel.reviews.includes(:user).order(created_at: :desc)
    @review  = Review.new
  end
end
