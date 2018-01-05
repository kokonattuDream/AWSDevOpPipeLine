#!/bin/sh
export NODE_ENV=production
export DB_PRD_HOST=devop.cnmmii20ccez.us-east-2.rds.amazonaws.com
export DB_PRD_USER=devop
export DB_PRD_PASS=devopdevop
export NODE_HOST=localhost
export NODE_PORT=8080
node /myapp/index.js&
exit 0
