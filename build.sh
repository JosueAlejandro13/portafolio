#!/bin/bash
set -e

echo "Preparando el entorno para compilar Flutter en Netlify..."

# Descargar flutter si no está presente
if [ ! -d "flutter" ]; then
  echo "Descargando Flutter..."
  git clone https://github.com/flutter/flutter.git -b stable
fi

# Agregar Flutter al PATH
export PATH="$PATH:`pwd`/flutter/bin"

echo "Instalando dependencias..."
flutter pub get

echo "Compilando la aplicación para la web..."
flutter build web --release

echo "¡Compilación terminada con éxito!"
