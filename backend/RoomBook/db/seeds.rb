puts "== Очистка базы =="
Review.delete_all
Booking.delete_all
Room.delete_all
Hotel.delete_all
User.delete_all

puts "== Пользователи =="
guest = User.create!(
  email: "guest@fastbooking.ru", password: "password123", password_confirmation: "password123",
  first_name: "Иван", last_name: "Петров", role: :guest
)

guest2 = User.create!(
  email: "anna@fastbooking.ru", password: "password123", password_confirmation: "password123",
  first_name: "Анна", last_name: "Смирнова", role: :guest
)

host = User.create!(
  email: "host@fastbooking.ru", password: "password123", password_confirmation: "password123",
  first_name: "Сергей", last_name: "Кузнецов", role: :host
)

host2 = User.create!(
  email: "host2@fastbooking.ru", password: "password123", password_confirmation: "password123",
  first_name: "Марина", last_name: "Волкова", role: :host
)

puts "== Отели =="
sea_breeze = host.hotels.create!(
  name: "Морской бриз",
  city: "Севастополь",
  address: "ул. Набережная, 12",
  description: "Отель в 100 метрах от моря. Заезд с 14:00, выезд до 12:00. " \
               "На территории бесплатная парковка, завтрак включён в стоимость."
)

sunny_pier = host.hotels.create!(
  name: "Солнечный причал",
  city: "Ялта",
  address: "Набережная имени Ленина, 5",
  description: "Современный отель с видом на горы. Круглосуточная стойка регистрации."
)

capital_inn = host2.hotels.create!(
  name: "Capital Inn",
  city: "Москва",
  address: "ул. Тверская, 18, стр. 1",
  description: "Деловой отель в центре Москвы рядом с метро. Подходит для командировок."
)

puts "== Номера =="
std = sea_breeze.rooms.create!(
  name: "Стандарт 2-местный",
  capacity: 2,
  price_per_night: 3_500,
  description: "Две односпальные кровати или одна двуспальная, санузел с душем, телевизор.",
  amenities: "Wi-Fi, Кондиционер, Телевизор, Душ"
)

sea_breeze.rooms.create!(
  name: "Семейный люкс",
  capacity: 4,
  price_per_night: 7_200,
  description: "Две комнаты, балкон с видом на море, мини-кухня, ванна.",
  amenities: "Wi-Fi, Балкон, Кондиционер, Ванна, Кухня"
)

sunny_pier.rooms.create!(
  name: "Стандарт с видом на горы",
  capacity: 2,
  price_per_night: 4_100,
  description: "Уютный номер с панорамным окном.",
  amenities: "Wi-Fi, Кондиционер, Балкон"
)

biz = capital_inn.rooms.create!(
  name: "Бизнес-одноместный",
  capacity: 1,
  price_per_night: 5_500,
  description: "Рабочий стол, сейф, ускоренный Wi-Fi.",
  amenities: "Wi-Fi, Сейф, Кондиционер, Рабочая зона"
)

capital_inn.rooms.create!(
  name: "Люкс",
  capacity: 3,
  price_per_night: 11_000,
  description: "Просторный номер с гостиной зоной.",
  amenities: "Wi-Fi, Кондиционер, Ванна, Гостиная"
)

puts "== Бронирования =="
b1 = guest.bookings.create!(
  room: std, check_in: Date.current + 5, check_out: Date.current + 8, guests_count: 2
)
b1.update!(status: :confirmed)

guest.bookings.create!(
  room: sea_breeze.rooms.second,
  check_in: Date.current + 14, check_out: Date.current + 16, guests_count: 3
)

b3 = guest2.bookings.create!(
  room: biz, check_in: Date.current - 20, check_out: Date.current - 17, guests_count: 1
)
b3.update!(status: :confirmed)

b4 = guest.bookings.create!(
  room: std, check_in: Date.current - 40, check_out: Date.current - 38, guests_count: 2
)
b4.update!(status: :confirmed)

puts "== Отзывы =="
Review.create!(
  user: guest2, hotel: capital_inn, booking: b3, rating: 4,
  body: "Удобное расположение, но завтрак скромный."
)

Review.create!(
  user: guest, hotel: sea_breeze, booking: b4, rating: 5,
  body: "Великолепный вид и очень отзывчивый персонал."
)

puts "\n== Готово =="
puts "Гость:      guest@fastbooking.ru / password123"
puts "Гость 2:    anna@fastbooking.ru  / password123"
puts "Владелец:   host@fastbooking.ru  / password123"
puts "Владелец 2: host2@fastbooking.ru / password123"
