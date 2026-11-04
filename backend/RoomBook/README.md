
# RoomBook (API)

Rails 7.1 (API-only) + PostgreSQL.

## 🚀 Запуск

```
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Сервер поднимается на `http://localhost:3000`.

## 🧪 Тесты

```
bin/rails test
```

## 🔌 API Контракт (camelCase)

Фронтенд (CRA/React) общается с API по токену: `Authorization: Bearer <token>`.

### Публичные эндпоинты

- `POST /api/v1/signup` — принимает `firstName`, `passwordConfirmation`
- `POST /api/v1/login` — возвращает `{ token, user: { id, email, firstName, lastName, fullName, role } }`
- `GET /api/v1/hotels`

Query params: `city` (или `destination`), `check_in` (или `checkIn`),
`check_out` (или `checkOut`), `guests` (или `guestsCount`),
`min_price`, `max_price`, `page`.
Фильтры `min_price`/`max_price` работают по минимальной цене номера отеля
(`pricePerNight`).
Ответ: `{ hotels: [...], meta: { currentPage, totalPages, totalCount } }`
- `GET /api/v1/hotels/:id` — `{ ...hotel, rooms: [...], reviews: [...] }`

### Гость (Bearer Token)

- `POST /api/v1/hotels/:hotel_id/bookings` — тело `{ roomId, checkIn, checkOut, guestsCount }`
- `GET /api/v1/guest/bookings?status=upcoming|completed|cancelled|pending`
- `PATCH /api/v1/guest/bookings/:id/cancel`
- `POST /api/v1/hotels/:hotel_id/reviews` — тело `{ rating, body }`

### Владелец (Bearer Token)

- `GET/POST/PATCH/DELETE /api/v1/host/hotels[/:id]`
- `GET/POST/PATCH/DELETE /api/v1/host/hotels/:hotel_id/rooms[/:id]`
- `GET /api/v1/host/bookings?hotel_id=`
- `PATCH /api/v1/host/bookings/:id/confirm`
- `PATCH /api/v1/host/bookings/:id/reject`

### Формат ошибок

- `401/403/404/400` → `{ "error": "Сообщение" }`
- `422` → `{ "errors": ["Ошибка 1", "Ошибка 2"] }`

### Logout

`DELETE /api/v1/logout` — идемпотентный (можно вызывать без токена, вернёт 204).

## ⚙️ CORS

Разрешены порты `localhost:3000` (CRA) и `localhost:5173` (Vite).

## 🔐 Credentials

`config/credentials.yml.enc` в репозиторий не включён.

- В dev `secret_key_base` хранится в `tmp/local_secret.txt` (создаётся автоматически).
- Для production задайте `RAILS_MASTER_KEY` или пересоздайте credentials:
`bin/rails credentials:edit`.

