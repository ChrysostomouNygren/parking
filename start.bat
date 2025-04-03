@echo off

echo Starting Dart-server...
start cmd /k "dart run lib/server.dart"

timeout /t 2 >nul

echo 📱 Starting Flutter-app...
start cmd /k "flutter run"
