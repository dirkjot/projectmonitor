#!/bin/bash
service mysqld start 
rake start_workers
rails server -e production 2>&1
