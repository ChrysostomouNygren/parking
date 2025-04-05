#!/bin/bash

# Starts server & app
echo "Starting the Dart server..."
dart run lib/server.dart &

sleep 2

echo "Startar the Flutter application..."
flutter run
