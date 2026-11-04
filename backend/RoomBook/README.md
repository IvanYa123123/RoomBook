
# RoomBook (API)

Rails 7.1 (API-only) + PostgreSQL.

## Запуск

bundle install
bin/rails db:create db:migrate db:seed
bin/rails server

Если `bin/rails` не исполняется (Windows), используйте:

bundle exec rails db:create db:migrate db:seed
bundle exec rails server

## Тесты

bin/rails test

</BDS:create_file>

<BDS:create_file fileName="backend/RoomBook/setup.bat">```batch
@echo off
echo Генерация файлов без расширений и скрытых файлов...
echo require_relative "config/environment" > config.ru
echo run Rails.application >> config.ru
echo Rails.application.load_server >> config.ru
echo 3.3.12 > .ruby-version
if not exist bin mkdir bin
echo #!/usr/bin/env ruby > bin\rails
echo APP_PATH = File.expand_path("../config/application", __dir__) >> bin\rails
echo require_relative "../config/boot" >> bin\rails
echo require "rails/commands" >> bin\rails
echo #!/usr/bin/env ruby > bin\rake
echo require_relative "../config/boot" >> bin\rake
echo require "rake" >> bin\rake
echo Rake.application.run >> bin\rake
echo Готово! Все файлы созданы.
pause

