#!/bin/bash

if [ -z "$1" ]; then
    echo "❌ Укажите имя сабмодуля для удаления."
    echo "Пример: $0 tmux_config"
    exit 1
fi

MODULE_NAME="$1"

echo "🧹 Удаление сабмодуля: $MODULE_NAME"

# Деинициализация сабмодуля
git submodule deinit -f "$MODULE_NAME"

# Добавляю в стэйджинг чтобы на следующем шаге не возникала ошибка
git add .gitmodules

# Удаляем сабмодуль из индекса
if git rm --cached "$MODULE_NAME"; then
    echo "📦 Сабмодуль успешно удалён из индекса: $MODULE_NAME"
else
    echo "❌ Ошибка удаления из индекса. Проверь состояние git."
    exit 1
fi

# Удаляем рабочую директорию сабмодуля
rm -rf "$MODULE_NAME"

# Удаляем внутренний репозиторий сабмодуля
rm -rf ".git/modules/$MODULE_NAME"

# Открываем .gitmodules для ручного редактирования с поиском по имени сабмодуля
if [ -f .gitmodules ]; then
    echo "📂 Открываем .gitmodules в vim..."
    sleep 1
    vim +"/$MODULE_NAME" .gitmodules
fi

echo "✅ Готово. Не забудь сделать коммит вручную при необходимости."
