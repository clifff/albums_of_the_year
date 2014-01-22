class LastFmUser
  def self.redis_set_key
    "usernames_with_data"
  end

  def self.top_albums_for_username(username)
    albums = []
    (1..2).each do |page|
      top_albums = LastFmApi.get_top_albums(:user => username, :page => page, :period => '12month')
      if top_albums
        top_albums.each do |mbid|
          album = LastFmApi.get_album(:mbid => mbid)
          #next if album['releasedate'] != 2013
          albums << album
        end
      end
    end
    albums
  end
end
