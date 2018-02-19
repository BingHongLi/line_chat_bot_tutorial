#!/bin/bash
set -ex

# SET THE FOLLOWING VARIABLES
# docker hub username
USERNAME=binghongli
# image name
IMAGE=line_bot_python
version=`cat VERSION`

create_line_bot()
{
docker run --name line-chat-bot-jupyter -p 8888:8888 -p 80:5000 -v $(pwd)/material:/home/jovyan/work -d $USERNAME/$IMAGE:$version start-notebook.sh --NotebookApp.token=''
docker run --name line-ngrok -d -p 4040 --link line-chat-bot-jupyter wernight/ngrok ngrok http line-chat-bot-jupyter:5000
sleep 5s
curl $(docker port line-ngrok 4040)/api/tunnels > tunnels.json
docker run -v $(pwd)/tunnels.json:/tmp/tunnels.json --rm  realguess/jq jq .tunnels[1].public_url /tmp/tunnels.json 
}

# 必須偵測container是否已經存在，進而做判斷
if [ `docker ps -a |grep line-chat-bot-jupyter | wc -l`  =  0  ]; then
  create_line_bot
else
  docker rm -f line-chat-bot-jupyter
  docker rm -f line-ngrok
  create_line_bot
fi

