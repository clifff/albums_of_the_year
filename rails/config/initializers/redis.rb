class Redis
  def self.new_redis_client
    Redis.new
  end
end

$redis = Redis.new_redis_client
