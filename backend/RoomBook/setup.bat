...

То есть `setup.bat` всё ещё «живёт» внутри README. Это не ломает запуск, но:

- `README.md` нечитаемый;
- `setup.bat` не существует как отдельный файл.

**Починить:** открыть `README.md`, обрезать после `bin/rails test`, а блок с `setup.bat` вынести в отдельный файл `setup.bat` в корне `backend/RoomBook/`.

**❌ В дереве нет `config.ru`, `bin/`, `.ruby-version`** — их должен создать `setup.sh`. Пока ты не запустишь:

```
cd backend/RoomBook
bash setup.sh
```

`bin/rails ...` из README не заработает. Это не баг, а обязательный шаг онбординга — **допиши в README первым шагом `bash setup.sh`**, иначе новый человек споткнётся.

**Логика/тесты** — без изменений, всё по-прежнему ок.

# Фронтенд — заметно лучше, но всё ещё не собирается

**✅ Починено**

- `Layout` теперь прокидывает `onRegisterClick` → кнопка «Зарегистрироваться» открывает `/reg` ✓
- В `AppRoutes` добавлен `/reg` ✓
- `RegistrationPage` — полноценная Formik+Yup форма с полями email/firstName/lastName/password/radio ✓
- `Auth.module.css` расширен под страницу (`pageContainer`, `card`, `formGroup`, `radioGroup`, `submitBtn` и т.д.) ✓
- `tsconfig` — `moduleResolution: "node"` вместо `"bundler"` (правильно для CRA5) ✓
- `PasswordField` больше не ломается на `IoEye as any` (костыль, но работает) ✓

**❌ Блокеры сборки (как были)**

1. **Нет `src/assets/`** — импорты `map-marker.png`, `calendar.png`, `person.png`, `search_white.png`, `logo.png`, `hero-bg.jpg`, `hotel1..6.jpg`, соц-иконок → билд падает.
2. **`Footer.module.css`** — вложенные `@media` и `&:hover` внутри правил; CRA5/postcss может не распарсить. Вынеси `@media` и `:hover` на верхний уровень.
3. **`react-app-env.d.ts`** — `declare module '*.css'` конфликтует с CSS-модулями CRA; оставь только `/// <reference types="react-scripts" />`.
4. **`@types/react@19` + `react-scripts@5`** — официально несовместимы. Либо `@types/react@^18`, либо переезд на Vite.

**❌ Функциональные дыры**

5. **`LoginPage.tsx` пустой** — возвращает пустой фрагмент. Роута `/login` в `AppRoutes` нет. Кнопка «Войти» в `Header` по-прежнему не подключена: `Layout` передаёт только `onRegisterClick`, а `onLoginClick` не задан.
6. **`RegistrationPage` не ходит в API** — `onSubmit` делает `console.log`, значения `'renter'|'landlord'` не маппятся в `guest|host` для `POST /api/v1/signup`. Итог: пользователь заполнит форму и ничего не произойдёт.
7. **Нет `AuthContext` / `api.ts`** — токен, `fetch` к `api/v1/*`, `Authorization: Bearer` отсутствуют. `hotels_data.ts` — мок, страницы каталога нет.
8. **`index.html`/`manifest.json`** — по-прежнему дефолтные CRA (title «React App», favicon нет).

**Резюме:** бэкенд готов к запуску после `bash setup.sh` и чистки README. Фронтенд **не запустится** из-за отсутствующих ассетов; даже если их добавить — `/reg` отрендерится, но сабмит ничего не сделает, а `/login` недостижим. Следующий шаг по важности: **папка `src/assets/` с картинками** → потом `LoginPage` + `/login` route + `onLoginClick` → потом API-слой.
