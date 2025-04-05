#!/bin/bash

echo "Killing the Dart server..."

# Kills the server
PID=$(lsof -ti tcp:8080)

if [ -z "$PID" ]; then
  echo "No server was found at port 8080"
else
  kill -9 $PID
  echo "The server (PID $PID) is now down"
fi
