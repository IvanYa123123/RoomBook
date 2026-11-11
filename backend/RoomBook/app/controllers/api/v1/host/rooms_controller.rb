module Api
  module V1
    module Host
      class RoomsController < BaseController
        before_action :require_host!
        before_action :set_hotel
        before_action :set_room, only: %i[update destroy]

        def index
          rooms = @hotel.rooms.with_attached_photos.order(:price_per_night)
          render json: { rooms: rooms.map { |r| RoomSerializer.call(r, request) } }
        end

        def create
          room = @hotel.rooms.new(room_params.except(:remove_photo_ids, :photos))
          room.photos.attach(params.dig(:room, :photos)) if params.dig(:room, :photos).present?

          if room.save
            render json: { room: RoomSerializer.call(room, request) }, status: :created
          else
            render_errors(room)
          end
        end

        def update
          # Транзакция: purge_photos откатится, если update! упадёт.
          ActiveRecord::Base.transaction do
            purge_photos
            @room.photos.attach(params.dig(:room, :photos)) if params.dig(:room, :photos).present?
            @room.update!(room_params.except(:remove_photo_ids, :photos))
          end

          render json: { room: RoomSerializer.call(@room, request) }
        rescue ActiveRecord::RecordInvalid
          render_errors(@room)
        end

        def destroy
          active = @room.bookings.where(status: %i[pending confirmed])
                        .where("check_out >= ?", Date.current).exists?

          if active
            render json: { error: "Нельзя удалить номер: есть активные бронирования" },
                   status: :unprocessable_entity
          else
            @room.destroy
            head :no_content
          end
        end

        private

        def set_hotel
          @hotel = current_user.hotels.find(params[:hotel_id])
        end

        def set_room
          @room = @hotel.rooms.find(params[:id])
        end

        def purge_photos
          ids = Array(params.dig(:room, :remove_photo_ids) || params.dig(:room, :removePhotoIds)).reject(&:blank?)
          @room.photos.where(id: ids).each(&:purge) if ids.any?
        end

        def room_params
          params.require(:room).permit(:name, :capacity, :price_per_night, :description, :amenities, photos: [], remove_photo_ids: [])
        end
      end
    end
  end
end
