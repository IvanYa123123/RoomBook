class Hotel < ApplicationRecord
  belongs_to :user

  has_many :rooms,    dependent: :destroy
  has_many :bookings, through: :rooms
  has_many :reviews,  dependent: :destroy

  has_many_attached :photos

  validates :name,    presence: true, length: { maximum: 120 }
  validates :city,    presence: true, length: { maximum: 80 }
  validates :address, presence: true, length: { maximum: 200 }

  # ИСПРАВЛЕНО: раньше был `where(...) if city.present?` — при пустом city
  # выражение возвращало nil, и следующий .with_price_between(...) падал
  # с NoMethodError на GET /api/v1/hotels без параметра city/destination.
  # Теперь при пустом/пробельном city возвращаем `all` — цепочка скопов
  # остаётся Relation-ом (как у with_price_between и bookable ниже).
  scope :in_city, lambda { |city|
    next all if city.blank?
    where("city ILIKE ?", "%#{sanitize_sql_like(city.to_s.strip)}%")
  }

  scope :with_price_between, lambda { |min_price, max_price|
    next all if min_price.blank? && max_price.blank?

    conds  = []
    values = []
    if min_price.present?
      conds  << "MIN(price_per_night) >= ?"
      values << min_price
    end
    if max_price.present?
      conds  << "MIN(price_per_night) <= ?"
      values << max_price
    end

    ids = Room.group(:hotel_id).having(conds.join(" AND "), *values).select(:hotel_id)
    where(id: ids)
  }

  # Отель проходит фильтр, только если существует ОДИН номер,
  # который одновременно вмещает гостей и свободен на выбранные даты.
  # Раньше with_capacity и available_between проверяли разные номера.
  scope :bookable, lambda { |guests:, check_in:, check_out:|
    guests_n = guests.present? ? guests.to_i : nil
    dates_ok = check_in.present? && check_out.present?

    next all if guests_n.nil? && !dates_ok

    rooms_scope = Room.all
    rooms_scope = rooms_scope.where("capacity >= ?", guests_n) if guests_n && guests_n.positive?

    if dates_ok
      busy = Booking.where(status: %i[pending confirmed])
                    .where("check_in < ? AND check_out > ?", check_out, check_in)
                    .select(:room_id)
      rooms_scope = rooms_scope.where.not(id: busy)
    end

    where(id: rooms_scope.select(:hotel_id))
  }

  def min_price
    rooms.minimum(:price_per_night)
  end

  # .to_f обязателен: BigDecimal в JSON сериализуется как строка ("4.5"),
  # а фронт делает rating.toFixed(1).
  def average_rating
    reviews.average(:rating)&.round(1)&.to_f
  end

  def reviews_count
    reviews.size
  end

  def pending_bookings_count
    bookings.pending.count
  end
end
