module Host
  class HotelsController < ApplicationController
    before_action :require_host
    before_action :set_hotel, only: %i[edit update destroy]

    def index
      @hotels = current_user.hotels
                            .with_attached_photos
                            .includes(:rooms)
                            .order(created_at: :desc)
    end

    def new
      @hotel = current_user.hotels.new
    end

    def create
      @hotel = current_user.hotels.new(hotel_params)

      if @hotel.save
        redirect_to host_hotels_path, notice: "Отель «#{@hotel.name}» добавлен"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      purge_photos
      @hotel.photos.attach(params.dig(:hotel, :photos)) if params.dig(:hotel, :photos).present?

      if @hotel.update(hotel_params.except(:photos, :remove_photo_ids))
        redirect_to host_hotels_path, notice: "Отель обновлён"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @hotel.destroy
      redirect_to host_hotels_path, notice: "Отель удалён"
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
      params.require(:hotel).permit(:name, :city, :address, :description, photos: [])
    end
  end
end
