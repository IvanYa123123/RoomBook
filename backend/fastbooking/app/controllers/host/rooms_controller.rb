module Host
  class RoomsController < ApplicationController
    before_action :require_host
    before_action :set_hotel
    before_action :set_room, only: %i[edit update destroy]

    def index
      @rooms = @hotel.rooms.with_attached_photos.order(created_at: :desc)
    end

    def new
      @room = @hotel.rooms.new(capacity: 1)
    end

    def create
      @room = @hotel.rooms.new(room_params)

      if @room.save
        redirect_to host_hotel_rooms_path(@hotel), notice: "Номер добавлен"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      purge_photos
      @room.photos.attach(params.dig(:room, :photos)) if params.dig(:room, :photos).present?

      if @room.update(room_params.except(:photos, :remove_photo_ids))
        redirect_to host_hotel_rooms_path(@hotel), notice: "Номер обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @room.bookings.where(status: %i[pending confirmed]).where("check_out >= ?", Date.current).exists?
        redirect_to host_hotel_rooms_path(@hotel),
                    alert: "Нельзя удалить номер: есть активные бронирования"
      else
        @room.destroy
        redirect_to host_hotel_rooms_path(@hotel), notice: "Номер удалён"
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
      ids = Array(params.dig(:room, :remove_photo_ids)).reject(&:blank?)
      @room.photos.where(id: ids).each(&:purge) if ids.any?
    end

    def room_params
      params.require(:room).permit(:name, :capacity, :price_per_night, :description, :amenities, photos: [])
    end
  end
end
