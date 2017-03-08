
# building pivotal projectmonitor on docker, with Farmers settings

# docker build -t figpulse  .
# docker run -it  -p 3000:3000 figpulse /bin/bash
# docker run -it --add-host=mysql:10.62.130.13 -p 3000:3000 figpulse /bin/bash

FROM ruby:2.3.1


RUN  \
  apt-get update && \
  apt-get install -y mysql-client && \
  apt-get install -y  nodejs && \
  gem install bundler && \
  git clone --branch figpulse --depth 1 https://github.com/dirkjot/projectmonitor.git && \
  cd projectmonitor && \
  bundle install

WORKDIR projectmonitor

COPY figpulse.configuration.yml /projectmonitor/figpulse.configuration.yml
COPY database.yml /projectmonitor/config/database.yml
COPY mysqlclient.sh /projectmonitor/
COPY initdb.sh /projectmonitor/




# default port for rails:
EXPOSE 3000

CMD [ "rails" "server" "-e production" "--binding=0.0.0.0"]
