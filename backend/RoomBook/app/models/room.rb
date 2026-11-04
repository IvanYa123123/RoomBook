class Room < ApplicationRecord
  belongs_to :hotel

  has_many :bookings, dependent: :destroy
  has_one :user, through: :hotel

  has_many_attached :photos

  validates :name, presence: true, length: { maximum: 120 }
  validates :capacity, presence: true,
                       numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }
  validates :price_per_night, presence: true,
                              numericality: { greater_than: 0 }

  scope :available_between, lambda { |check_in, check_out|
    next all if check_in.blank? || check_out.blank?

    busy = Booking.where(status: %i[pending confirmed])
                  .where("check_in < ? AND check_out > ?", check_out, check_in)
                  .select(:room_id)
    where.not(id: busy)
  }

  def amenities_list
    amenities.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  def available_between?(check_in, check_out)
    return false if check_in.blank? || check_out.blank?

    bookings.where(status: %i[pending confirmed])
            .where("check_in < ? AND check_out > ?", check_out, check_in)
            .none?
  end
end
