@echo off
chcp 65001 >nul
setlocal

echo === RoomBook setup ===
echo Generating config.ru, .ruby-version, bin\rails, bin\rake...

> config.ru echo require_relative "config/environment"
>> config.ru echo run Rails.application
>> config.ru echo Rails.application.load_server

> .ruby-version echo 3.3.12

if not exist bin mkdir bin

> bin\rails echo #!/usr/bin/env ruby
>> bin\rails echo APP_PATH = File.expand_path("../config/application", __dir__)
>> bin\rails echo require_relative "../config/boot"
>> bin\rails echo require "rails/commands"

> bin\rake echo #!/usr/bin/env ruby
>> bin\rake echo require_relative "../config/boot"
>> bin\rake echo require "rake"
>> bin\rake echo Rake.application.run

echo.
echo Done. config.ru, .ruby-version and bin\ created.
echo.
echo Next steps:
echo   bundle install
echo   bundle exec rails db:create db:migrate db:seed
echo   bundle exec rails server
endlocal
