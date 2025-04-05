@echo off

echo Starting the Dart server...
start cmd /k "dart run lib/server.dart"

timeout /t 2 >nul

echo Starting the Flutter application...
start cmd /k "flutter run"
