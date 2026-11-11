module Api
  module V1
    module Host
      class HotelsController < BaseController
        before_action :require_host!
        before_action :set_hotel, only: %i[update destroy]

        def index
          hotels = current_user.hotels
                               .with_attached_photos
                               .includes(:rooms, :reviews, photos_attachments: :blob)
                               .order(created_at: :desc)

          render json: { hotels: hotels.map { |h| HotelSerializer.card(h, request) } }
        end

        def create
          hotel = current_user.hotels.new(hotel_params.except(:remove_photo_ids, :photos))
          hotel.photos.attach(params.dig(:hotel, :photos)) if params.dig(:hotel, :photos).present?

          if hotel.save
            render json: { hotel: HotelSerializer.card(hotel, request) }, status: :created
          else
            render_errors(hotel)
          end
        end

        def update
          # Транзакция: если update! упадёт, purge_photos тоже откатится
          # (фото не потеряются).
          ActiveRecord::Base.transaction do
            purge_photos
            @hotel.photos.attach(params.dig(:hotel, :photos)) if params.dig(:hotel, :photos).present?
            @hotel.update!(hotel_params.except(:remove_photo_ids, :photos))
          end

          render json: { hotel: HotelSerializer.card(@hotel, request) }
        rescue ActiveRecord::RecordInvalid
          render_errors(@hotel)
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
          ids = Array(params.dig(:hotel, :remove_photo_ids) || params.dig(:hotel, :removePhotoIds)).reject(&:blank?)
          @hotel.photos.where(id: ids).each(&:purge) if ids.any?
        end

        def hotel_params
          params.require(:hotel).permit(:name, :city, :address, :description, photos: [], remove_photo_ids: [])
        end
      end
    end
  end
end
