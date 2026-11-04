class Review < ApplicationRecord
  belongs_to :user
  belongs_to :hotel
  belongs_to :booking

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :body, length: { maximum: 2_000 }, allow_blank: true
  validates :booking_id, uniqueness: true

  validate :booking_belongs_to_user_and_hotel
  validate :booking_is_completed

  private

  def booking_belongs_to_user_and_hotel
    return if booking.blank?
    errors.add(:booking, "не принадлежит пользователю") if booking.user_id != user_id
    errors.add(:booking, "не относится к этому отелю") if booking.room.hotel_id != hotel_id
  end

  def booking_is_completed
    return if booking.blank?
    errors.add(:booking, "ещё не завершено") unless booking.completed?
  end
end
