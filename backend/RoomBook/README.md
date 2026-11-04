
# RoomBook (API)

Rails 7.1 (API-only) + PostgreSQL.

## Требования

- Ruby 3.3.12
- PostgreSQL 14+
- Bundler

## Запуск

```
# 1. Сгенерировать системные файлы (config.ru, bin/rails, bin/rake, .ruby-version)
bash setup.sh

# 2. Установить зависимости
bundle install

# 3. Создать и подготовить БД
bin/rails db:create db:migrate db:seed

# 4. Запустить сервер
bin/rails server
```

Сервер поднимается на `http://localhost:3000`.

### Windows

Если `bin/rails` не запускается напрямую, выполните `setup.bat` вместо `setup.sh`, а затем используйте:

```
bundle exec rails db:create db:migrate db:seed
bundle exec rails server
```

### Переменные окружения (PostgreSQL)

По умолчанию: `localhost:5432`, пользователь `postgres`, пароль `postgres`.
Переопределяются через `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `RAILS_MAX_THREADS`.
Для production дополнительно задайте `ROOMBOOK_DATABASE_PASSWORD`.

## Тесты

```
bin/rails test
```

## Демо-аккаунты (после `db:seed`)

| Роль ↕▾ | E-mail ↕▾ | Пароль ↕▾ |
|---|---|---|
| −Гость | guest@fastbooking.ru | password123 |
| −Гость 2 | anna@fastbooking.ru | password123 |
| −Владелец | host@fastbooking.ru | password123 |
| −Владелец 2 | host2@fastbooking.ru | password123 |
⚙

## API Контракт (camelCase)

Авторизация: `Authorization: Bearer <token>`.
Все ответы — JSON. Даты — `YYYY-MM-DD`.

### Публичные эндпоинты

- `POST /api/v1/signup`
Body: `{ email, password, passwordConfirmation, firstName, lastName, role }`
`role`: `guest` | `host` (по умолчанию `guest`).
Ответ `201`: `{ token, user }`.
- `POST /api/v1/login`
Body: `{ email, password }`.
Ответ `200`: `{ token, user: { id, email, firstName, lastName, fullName, role } }`.
- `GET /api/v1/hotels`
Query: `city` (или `destination`), `check_in` (или `checkIn`),
`check_out` (или `checkOut`), `guests` (или `guestsCount`),
`min_price`, `max_price`, `page`.
Фильтры цены работают по минимальной цене номера отеля.
Ответ: `{ hotels: [...], meta: { currentPage, totalPages, totalCount } }`.
- `GET /api/v1/hotels/:id`
Ответ: `{ ...hotel, rooms: [...], reviews: [...] }`.

### Гость (Bearer)

- `POST /api/v1/hotels/:hotel_id/bookings`
Body: `{ roomId, checkIn, checkOut, guestsCount }`.
Ответ `201`: `{ booking }`. Бронь создаётся в статусе `pending`.
- `GET /api/v1/guest/bookings?status=upcoming|completed|cancelled|pending`
- `PATCH /api/v1/guest/bookings/:id/cancel`
Отменить можно только бронь в статусе `pending`.
- `POST /api/v1/hotels/:hotel_id/reviews`
Body: `{ rating, body }`. Доступно только после завершённого проживания.

### Владелец (Bearer)

- `GET/POST/PATCH/DELETE /api/v1/host/hotels[/:id]`
- `GET/POST/PATCH/DELETE /api/v1/host/hotels/:hotel_id/rooms[/:id]`
- `GET /api/v1/host/bookings?hotel_id=`
- `PATCH /api/v1/host/bookings/:id/confirm`
- `PATCH /api/v1/host/bookings/:id/reject`

### Прочее

- `GET /api/v1/me` — текущий пользователь по токену.
- `DELETE /api/v1/logout` — идемпотентный, всегда `204`.

## Формат ошибок

- `400` — `{ "error": "Неверные параметры запроса" }`
- `401` — `{ "error": "Требуется вход" }`
- `403` — `{ "error": "Доступно только гостям" | "Доступно только владельцам отелей" }`
- `404` — `{ "error": "Не найдено" }`
- `422` — `{ "errors": ["Ошибка 1", "Ошибка 2"] }`

## CORS

Разрешены origin'ы `http://localhost:3000` (CRA) и `http://localhost:5173` (Vite).

## Credentials

`config/credentials.yml.enc` в репозиторий не включён.

- В dev `secret_key_base` хранится в `tmp/local_secret.txt` (создаётся автоматически).
- Для production задайте `RAILS_MASTER_KEY` или пересоздайте credentials:

```
bin/rails credentials:edit
```

```

README готов — замени им текущий `backend/RoomBook/README.md` (в нём сейчас остался BDS-мусор с `setup.bat` в конце).
