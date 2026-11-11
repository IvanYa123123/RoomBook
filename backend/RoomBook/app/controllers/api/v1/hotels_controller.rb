module Api
  module V1
    class HotelsController < BaseController
      def index
        city = param_any(:city, :destination)
        check_in = parse_date(param_any(:check_in, :checkIn))
        check_out = parse_date(param_any(:check_out, :checkOut))
        guests = param_any(:guests, :guestsCount)
        min_price = param_any(:min_price, :minPrice)
        max_price = param_any(:max_price, :maxPrice)

        scope = Hotel.includes(:rooms, :reviews, photos_attachments: :blob).order(created_at: :desc)
        scope = scope.in_city(city)
                     .with_price_between(min_price, max_price)
                     .bookable(guests: guests, check_in: check_in, check_out: check_out)

        # per_page берётся из Kaminari.configure (9 по умолчанию)
        hotels = scope.page(params[:page])
        if hotels.total_pages.positive? && hotels.current_page > hotels.total_pages
          hotels = hotels.page(1)
        end

        render json: {
          hotels: hotels.map { |h| HotelSerializer.card(h, request) },
          meta: {
            currentPage: hotels.current_page,
            totalPages: hotels.total_pages,
            totalCount: hotels.total_count
          }
        }
      end

      def show
        hotel = Hotel.includes(
          rooms: { photos_attachments: :blob },
          reviews: :user,
          photos_attachments: :blob
        ).find(params[:id])

        render json: HotelSerializer.detail(hotel, request)
      end
    end
  end
end
