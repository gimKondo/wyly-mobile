#!/bin/bash

curl -X POST -H 'Content-type: application/json' --data '{"text":":danbo-: < '"${SLACK_MESSAGE}"'"}' ${SLACK_WEBHOOK_URL}
