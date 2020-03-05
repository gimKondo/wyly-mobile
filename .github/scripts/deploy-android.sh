
#!/bin/sh

curl \
  -F "token=$DEPLOYGATE_API_KEY" \
  -F "file=@./build/app/outputs/apk/debug/app-debug.apk" \
  -F "message=Daily build" \
  -F "distribution_key=437ee037f6d1c7f7111fd1ec8d8fca86698d1403" \
  -F "release_note=Daily build" \
  https://deploygate.com/api/users/gimKondo/apps
