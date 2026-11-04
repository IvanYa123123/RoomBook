class BookingSerializer < BaseSerializer
  def self.call(booking, request, with_user: false)
    data = {
      id: booking.id,
      status: booking.status,
      statusLabel: status_label(booking),
      checkIn: booking.check_in,
      checkOut: booking.check_out,
      nights: booking.nights,
      guestsCount: booking.guests_count,
      totalPrice: booking.total_price.to_f,
      createdAt: booking.created_at.iso8601,
      room: {
        id: booking.room.id,
        name: booking.room.name,
        photoUrl: photo_url(booking.room.photos.first, request)
      },
      hotel: {
        id: booking.room.hotel.id,
        name: booking.room.hotel.name,
        city: booking.room.hotel.city,
        address: booking.room.hotel.address
      }
    }

    if with_user
      data[:user] = {
        id: booking.user.id,
        fullName: booking.user.full_name,
        email: booking.user.email,
        firstName: booking.user.first_name
      }
    end

    data
  end

  def self.status_label(booking)
    if booking.pending? then "Ожидает подтверждения"
    elsif booking.cancelled? then "Отклонено"
    elsif booking.completed? then "Завершено"
    else "Подтверждено"
    end
  end
end
