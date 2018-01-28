#!/bin/bash
set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=binghongli
# image name
IMAGE=line_bot_python
version=`cat VERSION`

# 必須偵測container是否已經存在，進而做判斷
docker rm -rf line-chat-bot-jupter
docker run --name line-chat-bot-jupyter -p 8888:8888 -p 80:5000 -v $(pwd)/material:/home/jovyan/work -d $USERNAME/$IMAGE:$version

# 啟用ngrok
nohup ngrok/ngrok http -region ap 80 &
python ngrok/view_dns.py
