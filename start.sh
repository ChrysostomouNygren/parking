#!/bin/bash

echo "🚀 Startar Dart-server..."
dart run lib/server.dart &

sleep 2

echo "📱 Startar Flutter-app..."
flutter run
