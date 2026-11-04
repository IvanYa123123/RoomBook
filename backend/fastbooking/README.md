# FastBooking (Backend)

Rails 7.1 + PostgreSQL (API для React CRA).

## 🚀 Запуск

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

## 🧪 Тесты

```
bin/rails test
```

## 🔌 API Контракт (camelCase)

Фронтенд общается с API по токену: `Authorization: Bearer <token>`.

### Публичные эндпоинты

- `POST /api/v1/signup` (принимает `firstName`, `passwordConfirmation`)
- `POST /api/v1/login` → `{ token, user: { id, email, firstName, lastName, fullName, role } }`
- `GET /api/v1/hotels`

- Query params: `city` (или `destination`), `check_in` (или `checkIn`), `check_out` (или `checkOut`), `guests` (или `guestsCount`), `min_price`, `max_price`, `page`.
- Ответ: `{ hotels: [{ id, name, city, address, description, imageUrl, photos, rating, reviewsCount, pricePerNight }], meta: { currentPage, totalPages, totalCount } }`
- `GET /api/v1/hotels/:id` → `{ ...hotel, rooms: [...], reviews: [...] }`

### Гость (Bearer Token)

- `POST /api/v1/hotels/:hotel_id/bookings`

- Body: `{ roomId, checkIn, checkOut, guestsCount }` (или snake_case).
- `GET /api/v1/guest/bookings?status=upcoming|completed|cancelled|pending`
- `PATCH /api/v1/guest/bookings/:id/cancel`
- `POST /api/v1/hotels/:hotel_id/reviews` (Body: `{ rating, body }`)

### Владелец (Bearer Token)

- `GET/POST/PATCH/DELETE /api/v1/host/hotels[/:id]`
- `GET/POST/PATCH/DELETE /api/v1/host/hotels/:hotel_id/rooms[/:id]`
- `GET /api/v1/host/bookings?hotel_id=`
- `PATCH /api/v1/host/bookings/:id/confirm`
- `PATCH /api/v1/host/bookings/:id/reject`

### Формат ошибок

- `401/403/404/400` → `{ "error": "Сообщение" }`
- `422` → `{ "errors": ["Ошибка 1", "Ошибка 2"] }`

## ⚙️ CORS

Разрешены порты `localhost:3000` (CRA) и `localhost:5173` (Vite).

</BDS:create_file>
</BDS:LONG_WORK>

### Что сделано (по пунктам ТЗ):

1. **Починка сборки**: `HotelsController` и `BaseController` полностью перезаписаны, добавлены хелперы `render_errors`, `photo_urls`, `param_any`.
2. **Интеграция сериализаторов**: Все контроллеры (`bookings`, `guest/bookings`, `host/bookings`, `host/hotels`, `host/rooms`, `reviews`) переведены на использование `*Serializer.call`. Никаких дублирующих `serialize` больше нет. `BookingSerializer` дополнен полями `completed` и `reviewable`. `HotelSerializer` оптимизирован (`min_price_of`, `rating_of`).
3. **CamelCase на входе**: Везде, где нужно, параметры читаются через `param_any` (fallback с snake_case на camelCase).
4. **Единый формат ошибок**: Все ошибки теперь обрабатываются либо через `render_errors`, либо через `rescue_from` в `BaseController`.
5. **Тесты**: Добавлен файл `test/integration/api_test.rb`, в `test_helper.rb` добавлен метод `auth_headers`.
6. **README**: Обновлен под актуальный API и camelCase.

### Команды для ручной проверки:
Как только вы запустите `bin\rails server`, можете проверить работоспособность в новом терминале:

```bash
# 1. Каталог с camelCase полями
curl "http://localhost:3000/api/v1/hotels?destination=Севастополь"

# 2. Логин
curl -X POST http://localhost:3000/api/v1/login -H "Content-Type: application/json" -d "{\"email\":\"guest@fastbooking.ru\",\"password\":\"password123\"}"

# 3. Ошибка 404
curl -i http://localhost:3000/api/v1/hotels/999999
