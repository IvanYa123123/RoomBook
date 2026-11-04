class HotelSerializer < BaseSerializer
  def self.card(hotel, request)
    {
      id: hotel.id,
      name: hotel.name,
      city: hotel.city,
      address: hotel.address,
      description: hotel.description,
      imageUrl: photo_url(hotel.photos.first, request),
      photos: photos(hotel, request),
      rating: hotel.average_rating,
      reviewsCount: hotel.reviews.size,
      pricePerNight: hotel.min_price&.to_f
    }
  end

  def self.detail(hotel, request)
    card(hotel, request).merge(
      rooms: hotel.rooms.order(:price_per_night).map { |room| RoomSerializer.call(room, request) },
      reviews: hotel.reviews.order(created_at: :desc).map { |review| ReviewSerializer.call(review) }
    )
  end
end
