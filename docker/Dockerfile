
# building pivotal projectmonitor on docker, with Farmers settings


FROM centos:6.8
# SHOULD UPDATE centos:7.3.1611

RUN  \
  yum -y install gcc ; \
  yum -y install wget ; \
  yum -y install git ; \
  curl -sSL https://rvm.io/mpapis.asc | gpg2 --import - ; \
  curl -sSL https://get.rvm.io | bash -s stable ; \
  source /etc/profile.d/rvm.sh ; \
  rvm install 2.3.3 ; \
  gem install bundler ; \
  yum -y install mysql-server ; \
  yum -y install mysql ; \
  yum -y install mysql-devel ; \
  curl --silent --location https://rpm.nodesource.com/setup_6.x > nodesetup.sh ; \
  bash nodesetup.sh ; \
  yum -y install -y nodejs ; \
  git clone https://github.com/dirkjot/projectmonitor.git ; \
  git checkout figpulse ; \
  cd projectmonitor ; \
  bundle install

WORKDIR projectmonitor
COPY docker-start.sh ./
COPY figpulse.configuration.yml ./
RUN chmod u+x ./docker-start.sh

RUN  \
  service mysqld start ; \
  rake setup ; \
  RAILS_ENV=production rake db:create ; \
  RAILS_ENV=production rake db:migrate ; \
  env PROJECT_MONITOR_LOGIN=profburke PROJECT_MONITOR_EMAIL=noreply@pivotal.io PROJECT_MONITOR_PASSWORD=jk456simmons \
      RAILS_ENV=production rake db:seed ; \
  rake projectmonitor:import < figpulse.configuration.yml ; \
  service mysqld stop

# default port for rails:
EXPOSE 3000



CMD [ "/projectmonitor/docker-start.sh" ]
