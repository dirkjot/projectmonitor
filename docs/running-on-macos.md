

# Running ProjectMonitor on MacOS Sierra



## Software and requirements

We are not using all requirements here, specifically we are not installing Qt.  Qt is necessary for
testing ProjectMonitor but luckily not for running it.

(if you wanted to install Qt, there is [how to get it running on Sierra](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit); it will require a few hours to compile from source)

```
git clone git://github.com/pivotal/projectmonitor.git
cd projectmonitor
brew install ruby
gem install bundler
```

Now edit the Gemfile to remove these lines:
```
--- a/Gemfile
+++ b/Gemfile
@@ -70,12 +70,12 @@ group :test, :development do
   gem 'jshint_on_rails'
   gem 'rspec-rails'
   gem 'shoulda-matchers'
-  gem 'capybara'
+
   gem 'jasmine'
   gem 'factory_girl_rails'
   gem 'guard'
   gem 'database_cleaner'
-  gem 'capybara-webkit'
+
   gem 'pry-nav'
```

and run
```
bundle install
```


## get and setup the databases (mysql)

Mysql will be set up to run without a root password, not for prod use!  We will also start mysql by hand.  We create a `projmon` user with same password.


```
brew install mysql
mysql.server start
rake setup
RAILS_ENV=production rake db:create
RAILS_ENV=production rake db:migrate
env PROJECT_MONITOR_LOGIN=projmon PROJECT_MONITOR_EMAIL=noreply@pivotal.io PROJECT_MONITOR_PASSWORD=projmon RAILS_ENV=production rake db:seed


# if you also want a development db
rake db:create
rake db:migrate
env PROJECT_MONITOR_LOGIN=projmon PROJECT_MONITOR_EMAIL=noreply@pivotal.io PROJECT_MONITOR_PASSWORD=projmon  rake db:seed

```

## change the setup for production

NOTE that this is not optimal for handling large loads.  It is an easy way
got get running.

```
diff --git a/config/environments/production.rb b/config/environments/production.rb
index cad0698..97f8b9e 100644
--- a/config/environments/production.rb
+++ b/config/environments/production.rb
@@ -11,8 +11,8 @@ Rails.application.configure do
   config.eager_load = true

   # Full error reports are disabled and caching is turned on.
-  config.consider_all_requests_local       = false
-  config.action_controller.perform_caching = true
+  config.consider_all_requests_local       = true
+  config.action_controller.perform_caching = false

   # Enable Rack::Cache to put a simple HTTP cache in front of your application
   # Add `rack-cache` to your Gemfile before enabling this.
@@ -22,14 +22,14 @@ Rails.application.configure do

   # Disable serving static files from the `/public` folder by default since
   # Apache or NGINX already handles this.
-  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
+  config.serve_static_files = true

   # Compress JavaScripts and CSS.
   config.assets.js_compressor = :uglifier
   # config.assets.css_compressor = :sass

   # Do not fallback to assets pipeline if a precompiled asset is missed.
-  config.assets.compile = false
+  config.assets.compile = true

   # Asset digests allow you to set far-future HTTP expiration dates on all assets,
   # yet still be able to expire them through the digest params.
```

## start and connect

```
rake start_workers
rails server -e production 2>&1 | tee  projectmonitor.log

# for dev
rails server

```

now go to `localhost:3000` to view.


## raw history

```
mkdir .projectmonitor
cd .projectmonitor/
mkdir downloads
mkdir -p lokal/bin
# export PATH=/opt/bea/.projectmonitor/lokal/bin:${PATH}
export PATH=${PWD}/lokal/bin:${PATH}
cd downloads/

wget https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.3.tar.gz
tar xf ruby-2.3.3.tar.gz
cd ruby-2.3.3
./configure --prefix=/opt/bea/.projectmonitor/lokal
make
make install
cd ..

wget https://rubygems.org/rubygems/rubygems-2.6.10.tgz
tar xf rubygems-2.6.10.tgz
cd rubygems-2.6.10
ruby setup.rb
gem --version
cd ..

wget http://www.zlib.net/zlib-1.2.11.tar.gz
tar xf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure --prefix=/opt/bea/.projectmonitor/lokal
make
make install
cd ..

 ```
