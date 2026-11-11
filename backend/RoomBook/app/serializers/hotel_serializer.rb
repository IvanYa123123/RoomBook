class HotelSerializer < BaseSerializer
  def self.card(hotel, request)
    {
      id: hotel.id,
      name: hotel.name,
      city: hotel.city,
      address: hotel.address,
      description: hotel.description,
      imageUrl: photo_url(hotel.photos.first, request),
      rating: rating_of(hotel),
      reviewsCount: hotel.reviews.size,
      pricePerNight: min_price_of(hotel)&.to_f
    }
  end

  # Полный набор фото — только на странице отеля.
  # Раньше photos отдавались в каждом card → N×M url генераций в списке.
  def self.detail(hotel, request)
    card(hotel, request).merge(
      photos: photos(hotel, request),
      rooms: hotel.rooms.sort_by(&:price_per_night).map { |r| RoomSerializer.call(r, request) },
      reviews: hotel.reviews.sort_by { |rv| -rv.created_at.to_i }.map { |rv| ReviewSerializer.call(rv) }
    )
  end

  def self.min_price_of(hotel)
    if hotel.rooms.loaded?
      hotel.rooms.map(&:price_per_night).compact.min
    else
      hotel.min_price
    end
  end

  def self.rating_of(hotel)
    if hotel.reviews.loaded?
      hotel.reviews.map(&:rating).then { |a| a.empty? ? nil : (a.sum.to_f / a.size).round(1) }
    else
      hotel.average_rating
    end
  end
end
