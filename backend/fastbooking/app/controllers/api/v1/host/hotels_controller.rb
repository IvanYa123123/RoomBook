module Api
  module V1
    module Host
      class HotelsController < BaseController
        before_action :require_host!
        before_action :set_hotel, only: %i[update destroy]

        def index
          hotels = current_user.hotels.with_attached_photos.includes(:rooms).order(created_at: :desc)
          render json: { hotels: hotels.map { |h| serialize(h) } }
        end

        def create
          hotel = current_user.hotels.new(hotel_params.except(:remove_photo_ids, :photos))
          hotel.photos.attach(params.dig(:hotel, :photos)) if params.dig(:hotel, :photos).present?

          if hotel.save
            render json: { hotel: serialize(hotel) }, status: :created
          else
            render_errors(hotel)
          end
        end

        def update
          purge_photos
          @hotel.photos.attach(params.dig(:hotel, :photos)) if params.dig(:hotel, :photos).present?

          if @hotel.update(hotel_params.except(:remove_photo_ids, :photos))
            render json: { hotel: serialize(@hotel) }
          else
            render_errors(@hotel)
          end
        end

        def destroy
          @hotel.destroy
          head :no_content
        end

        private

        def set_hotel
          @hotel = current_user.hotels.find(params[:id])
        end

        def purge_photos
          ids = Array(params.dig(:hotel, :remove_photo_ids)).reject(&:blank?)
          @hotel.photos.where(id: ids).each(&:purge) if ids.any?
        end

        def hotel_params
          params.require(:hotel).permit(:name, :city, :address, :description, :remove_photo_ids, photos: [], remove_photo_ids: [])
        end

        def serialize(hotel)
          {
            id: hotel.id,
            name: hotel.name,
            city: hotel.city,
            address: hotel.address,
            description: hotel.description,
            photos: photo_urls(hotel),
            rooms_count: hotel.rooms.size,
            pending_bookings_count: hotel.pending_bookings_count
          }
        end
      end
    end
  end
end
