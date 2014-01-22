redis: redis-server
rails: bundle exec unicorn_rails -p 3000 -E development -c config/unicorn.rb
resque: bundle exec rake environment resque:work QUEUE=* 
