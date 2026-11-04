#!/bin/bash
echo "Генерация системных файлов..."

cat << 'EOF' > config.ru
require_relative "config/environment"
run Rails.application
Rails.application.load_server
EOF

echo "3.3.12" > .ruby-version
mkdir -p bin

cat << 'EOF' > bin/rails
#!/usr/bin/env ruby
APP_PATH = File.expand_path("../config/application", __dir__)
require_relative "../config/boot"
require "rails/commands"
EOF
chmod +x bin/rails

cat << 'EOF' > bin/rake
#!/usr/bin/env ruby
require_relative "../config/boot"
require "rake"
Rake.application.run
EOF
chmod +x bin/rake

echo "Готово! config.ru, .ruby-version и bin/ созданы."