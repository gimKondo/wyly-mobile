#!/bin/bash

curl -X POST -H 'Content-type: application/json' --data '{"text":":robot_face: < '"${SLACK_MESSAGE}"'"}' ${SLACK_WEBHOOK_URL}
