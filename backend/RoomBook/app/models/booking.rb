class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :room

  has_one :hotel, through: :room
  has_one :review, dependent: :destroy

  enum status: { pending: 0, confirmed: 1, cancelled: 2 }

  # Спасает от Booking.new без явного guests_count.
  # От явного nil в new(guests_count: nil) спасает default в контроллере (см. bookings_controller).
  attribute :guests_count, :integer, default: 1

  # Пересчитываем total_price только при первичной вставке
  # или при реальном изменении дат/номера. Иначе подтверждение брони
  # (update status) будет пересчитывать цену по актуальному тарифу номера,
  # что ломает историческую стоимость.
  before_validation :calculate_total_price,
                    if: -> { new_record? || will_save_change_to_check_in? ||
                             will_save_change_to_check_out? ||
                             will_save_change_to_room_id? }

  validates :check_in,  presence: true
  validates :check_out, presence: true
  validates :guests_count, numericality: { only_integer: true, greater_than: 0 }
  validates :total_price, numericality: { greater_than_or_equal_to: 0 }

  validate :check_out_after_check_in
  validate :check_in_not_in_past, on: :create
  validate :guests_fit_capacity
  validate :room_is_free, on: :create

  scope :awaiting_confirmation, -> { where(status: :pending) }
  scope :upcoming,  -> { where(status: :confirmed).where("check_in >= ?", Date.current) }
  scope :completed, -> { where(status: :confirmed).where("check_out < ?", Date.current) }

  def nights
    return 0 unless check_in && check_out
    (check_out - check_in).to_i
  end

  def completed?
    confirmed? && check_out.present? && check_out < Date.current
  end

  def upcoming?
    confirmed? && check_in.present? && check_in >= Date.current
  end

  def reviewable?
    completed? && review.nil?
  end

  private

  def calculate_total_price
    self.total_price = (nights * room.price_per_night).round(2) if room && nights.positive?
  end

  def check_out_after_check_in
    return if check_in.blank? || check_out.blank?
    errors.add(:check_out, "должна быть позже даты заезда") if check_out <= check_in
  end

  def check_in_not_in_past
    return if check_in.blank?
    errors.add(:check_in, "не может быть в прошлом") if check_in < Date.current
  end

  def guests_fit_capacity
    return if room.blank? || guests_count.blank?
    if guests_count > room.capacity
      errors.add(:guests_count, "не может превышать вместимость номера (#{room.capacity})")
    end
  end

  def room_is_free
    return if room.blank? || check_in.blank? || check_out.blank?
    return if errors[:check_out].any? || errors[:check_in].any?

    overlapping = room.bookings
                      .where(status: %i[pending confirmed])
                      .where.not(id: id)
                      .where("check_in < ? AND check_out > ?", check_out, check_in)

    errors.add(:base, "Номер уже забронирован на выбранные даты") if overlapping.exists?
  end
end
