module Api
  module V1
    class HotelsController < BaseController
      def index
        scope = Hotel.includes(:rooms, :reviews, photos_attachments: :blob).order(created_at: :desc)
        scope = scope.in_city(params[:city])
                     .with_capacity(params[:guests])
                     .with_price_between(params[:min_price], params[:max_price])
                     .available_between(parse_date(params[:check_in]), parse_date(params[:check_out]))

        hotels = scope.page(params[:page]).per(9)

        render json: {
          hotels: hotels.map { |h| serialize_card(h) },
          meta: {
            current_page: hotels.current_page,
            total_pages: hotels.total_pages,
            total_count: hotels.total_count
          }
        }
      end

      def show
        hotel = Hotel.includes(:rooms, reviews: :user, photos_attachments: :blob).find(params[:id])
        render json: serialize_detail(hotel)
      end

      private

      def serialize_card(hotel)
        {
          id: hotel.id,
          name: hotel.name,
          city: hotel.city,
          address: hotel.address,
          photos: photo_urls(hotel),
          min_price: hotel.min_price&.to_f,
          average_rating: hotel.average_rating,
          reviews_count: hotel.reviews_count
        }
      end

      def serialize_detail(hotel)
        serialize_card(hotel).merge(
          description: hotel.description,
          rooms: hotel.rooms.order(:price_per_night).map { |r| serialize_room(r) },
          reviews: hotel.reviews.order(created_at: :desc).map { |r| serialize_review(r) }
        )
      end

      def serialize_room(room)
        {
          id: room.id,
          name: room.name,
          capacity: room.capacity,
          price_per_night: room.price_per_night.to_f,
          description: room.description,
          amenities: room.amenities_list,
          photos: photo_urls(room)
        }
      end

      def serialize_review(review)
        {
          id: review.id,
          rating: review.rating,
          body: review.body,
          author_name: review.user.full_name,
          created_at: review.created_at.iso8601
        }
      end
    end
  end
end
