
#!/bin/sh

curl \
  -F "token=$DEPLOYGATE_API_KEY" \
  -F "file=@./build/app/outputs/apk/debug/app-debug.apk" \
  -F "message=Daily build" \
  https://deploygate.com/api/users/gimKondo/apps
