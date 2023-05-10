#!/bin/bash

          # get the private key from the github env and set  necessary permissions
          echo "$PRIVATE_KEY" > deploy_key && chmod 600 deploy_key

          # Login into remote server
          ssh -o StrictHostKeyChecking=no -i deploy_key ${USER_NAME}@${HOSTNAME}

          # set directory
          DIR="/zero-down-time-deployment-demo/"

          if [ -d "$DIR" ]; then

          # Take action if $DIR exists 

          # checkout the project folder
            cd $DIR

          else

            echo "Error: ${DIR} not found. Can not continue to cloning the project from github."
           
          # download the sources codes from github
            git clone https://github.com/bigelio/zero-down-time-deployment-demo.git
            cd $DIR

          fi

          # pull the latest changes
          git checkout develop &&
          git fetch --all &&
          git reset --hard origin/develop &&
          git pull origin develop;

          # install the required dependances
          npm i
          # start new instance of the app
          echo "PORT=$APP_PORT" > .env

          pm2 start --name v$VERSION app.js

          # setup nginx

          sudo rm -f /etc/nginx/site-enabled/default
          sudo cp templ.nginx /etc/nginx/sites-available/api.mycodepay.com-v$VERSION
          sudo ln -s /etc/nginx/sites-available/api.mycodepay.com-v$VERSION /etc/nginx/sites-enabled

          sudo systemctl reload nginx
          # Relax the server
          sleep 10
          sudo rm -v !("/etc/nginx/sites-enabled/api.mycodepay.com-v$VERSION")
          # logout
          logout