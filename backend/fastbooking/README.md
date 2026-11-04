# FastBooking

Сервис посуточного бронирования отелей. Rails 7.1 + PostgreSQL (backend) и React + Vite + TypeScript (frontend).

## 🚀 Быстрый старт (Windows)

### 0. Что установить

- **Ruby 3.2.2 + DevKit** — https://rubyinstaller.org/downloads/ → в конце установки `ridk install` → вариант **3**
- **PostgreSQL 16** — https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
- **Node.js 20 LTS** — https://nodejs.org

Проверить в **новом** `cmd`:

```

ruby -v
gem -v
bundle -v
node -v
npm -v
psql --version

```

Если `bundle` не найден — `gem install bundler`.

### 1. База данных

Пароль по умолчанию в `config/database.yml` — `postgres/postgres`. Если у вас другой, задайте переменные:

```

set PGHOST=localhost
set PGUSER=postgres
set PGPASSWORD=ваш_пароль

```

### 2. Backend

```

cd C:\fastbooking
bundle install
bin\rails db:create
bin\rails db:migrate
bin\rails db:seed
bin\rails server

```

Если `pg` не собирается:
```

gem install pg -- --with-pg-dir="C:\Program Files\PostgreSQL\16"
bundle install

```

### 3. Frontend (в отдельном окне cmd)

```

cd C:\fastbooking\frontend
copy .env.example .env
npm install
npm run dev

```

- Backend → http://localhost:3000
- Frontend (React) → http://localhost:5173
- ERB-версия (тот же бэкенд) → http://localhost:3000

### 🧪 Тесты

```

cd C:\fastbooking
bin\rails test

```

Ожидается `0 failures, 0 errors`.

### 🧑 Демо-аккаунты

| Роль     | E-mail                  | Пароль        |
|----------|-------------------------|---------------|
| Гость    | `guest@fastbooking.ru`  | `password123` |
| Гость 2  | `anna@fastbooking.ru`   | `password123` |
| Владелец | `host@fastbooking.ru`   | `password123` |
| Владелец | `host2@fastbooking.ru`  | `password123` |

## 📁 Структура

- `app/` — Rails: модели, контроллеры, ERB-вьюхи
- `app/controllers/api/v1/` — JSON API для React
- `config/` — конфиги, роуты, локали, CORS
- `db/` — миграции и seed-данные
- `test/` — unit + integration-тесты (Minitest)
- `frontend/` — React SPA (Vite + TS)

## 🔌 API

Авторизация: `Authorization: Bearer <token>`. Токен выдаётся в `POST /api/v1/signup` / `POST /api/v1/login`.

### Публичные

| Метод | Путь |
|-------|------|
| GET   | `/api/v1/hotels?city=&check_in=&check_out=&guests=&min_price=&max_price=&page=` |
| GET   | `/api/v1/hotels/:id` |
| POST  | `/api/v1/signup` |
| POST  | `/api/v1/login` |
| GET   | `/api/v1/me` |
| DELETE| `/api/v1/logout` |

### Гость

| Метод | Путь |
|-------|------|
| POST  | `/api/v1/hotels/:hotel_id/bookings` |
| POST  | `/api/v1/hotels/:hotel_id/reviews` |
| GET   | `/api/v1/guest/bookings?status=` |
| PATCH | `/api/v1/guest/bookings/:id/cancel` |

### Владелец

| Метод | Путь |
|-------|------|
| GET/POST/PATCH/DELETE | `/api/v1/host/hotels[/:id]` |
| GET/POST/PATCH/DELETE | `/api/v1/host/hotels/:hotel_id/rooms[/:id]` |
| GET   | `/api/v1/host/bookings?hotel_id=` |
| PATCH | `/api/v1/host/bookings/:id/confirm` |
| PATCH | `/api/v1/host/bookings/:id/reject` |

Фотографии в JSON отдаются как `photos: [{ id, url }]`. Загрузка — `multipart/form-data` по полям `photos[]` и `remove_photo_ids[]`.

## 🗄 Модель данных

```

User (email, password_digest, first_name, last_name, role: guest|host, api_token)
Hotel (user_id, name, city, address, description) + photos
Room (hotel_id, name, capacity 1..10, price_per_night > 0, description, amenities) + photos
Booking (user_id, room_id, check_in, check_out, guests_count, total_price, status: pending|confirmed|cancelled)
Review (user_id, hotel_id, booking_id UNIQUE, rating 1..5, body)

```

## 🩺 Диагностика

- **`bundle install` падает на `pg`** → `gem install pg -- --with-pg-dir="C:\Program Files\PostgreSQL\16"`
- **`PG::ConnectionBad`** → PostgreSQL запущен? `pg_ctl status` или проверка службы
- **`ActiveRecord::PendingMigrationError`** → `bin\rails db:migrate`
- **Frontend не грузит отели** → проверьте CORS: в `config/initializers/cors.rb` должны быть `localhost:5173` и `127.0.0.1:5173`
- **`db:seed` падает** → `bin\rails db:drop db:create db:migrate db:seed` (сотрёт данные)
