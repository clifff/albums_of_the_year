class LastFmUser
  def self.redis_set_key
    "usernames_with_data"
  end

  def self.top_albums_for_username(username)
    albums = []
    (1..5).each do |page|
      top_albums = LastFmApi.get(:method => 'user.gettopalbums', :user => username, :page => page, :period => '12month')
      if top_albums['topalbums']['album']
        top_albums['topalbums']['album'].each do |album|
          next if album['mbid'].blank?
          album = LastFmApi.get_album(:mbid => album['mbid'])
          next if album['releasedate'] != 2012
          albums << album
        end
      end
    end
    albums
  end
end
