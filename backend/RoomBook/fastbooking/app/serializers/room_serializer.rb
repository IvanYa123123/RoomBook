class RoomSerializer < BaseSerializer
  def self.call(room, request)
    {
      id: room.id,
      name: room.name,
      capacity: room.capacity,
      pricePerNight: room.price_per_night.to_f,
      description: room.description,
      amenities: room.amenities_list,
      photos: photos(room, request)
    }
  end
end
