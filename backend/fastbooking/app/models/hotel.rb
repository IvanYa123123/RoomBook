class Hotel < ApplicationRecord
  belongs_to :user

  has_many :rooms,    dependent: :destroy
  has_many :bookings, through: :rooms
  has_many :reviews,  dependent: :destroy

  has_many_attached :photos

  validates :name,    presence: true, length: { maximum: 120 }
  validates :city,    presence: true, length: { maximum: 80 }
  validates :address, presence: true, length: { maximum: 200 }

  scope :in_city, ->(city) { where("city ILIKE ?", "%#{sanitize_sql_like(city.to_s.strip)}%") if city.present? }

  scope :with_capacity, lambda { |guests|
    next all if guests.blank?
    where(id: Room.where("capacity >= ?", guests.to_i).select(:hotel_id))
  }

  scope :with_price_between, lambda { |min_price, max_price|
    scope = all
    scope = scope.where(id: Room.where("price_per_night >= ?", min_price).select(:hotel_id)) if min_price.present?
    scope = scope.where(id: Room.where("price_per_night <= ?", max_price).select(:hotel_id)) if max_price.present?
    scope
  }

  scope :available_between, lambda { |check_in, check_out|
    next all if check_in.blank? || check_out.blank?

    busy_rooms = Booking.where(status: %i[pending confirmed])
                        .where("check_in < ? AND check_out > ?", check_out, check_in)
                        .select(:room_id)

    where(id: Room.where.not(id: busy_rooms).select(:hotel_id))
  }

  def min_price
    rooms.minimum(:price_per_night)
  end

  def average_rating
    reviews.average(:rating)&.round(1)
  end

  def reviews_count
    reviews.size
  end

  def pending_bookings_count
    bookings.pending.count
  end
end
