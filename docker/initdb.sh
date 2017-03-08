#!/bin/bash

cd /projectmonitor

export RAILS_ENV=production
rake db:create
rake db:migrate
PROJECT_MONITOR_LOGIN=profburke PROJECT_MONITOR_EMAIL=noreply@pivotal.io PROJECT_MONITOR_PASSWORD=jk456simmons \
      rake db:seed
rake projectmonitor:import < figpulse.configuration.yml
mysql --host=mysqlserver --user=root --password=xxx  projectmonitor_production \
   -e "select count(*) from projects; select name from projects limit 5; select * from users"
