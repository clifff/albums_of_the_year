class GetLastFmDataResqueJob
  @queue = :get_lastfm_data

  def self.perform(username)
    LastFmUser.top_albums_for_username(username)
    $redis.sadd(LastFmUser.redis_set_key, username)
  end
end
