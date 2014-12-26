class Redis
  def self.new_redis_client
    Redis.new(:host => ENV['REDIS_PORT_6379_TCP_ADDR'], :port => ENV['REDIS_PORT_6379_TCP_PORT'])
  end
end

$redis = Redis.new_redis_client
