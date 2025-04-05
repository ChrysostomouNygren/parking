@echo off
echo Killing the Dart server...

for /f "tokens=5" %%a in ('netstat -aon ^| find ":8080" ^| find "LISTENING"') do (
    echo Found the process with PID %%a
    taskkill /F /PID %%a
    echo Servern is now down
    goto done
)

echo No server was found at port 8080

:done
