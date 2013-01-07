class PagesController < ApplicationController
  def index
  end

  def lastfm_bestof
    @albums = []
    @username = params[:username]

    (1..5).each do |page|
      top_albums = LastFmApi.get(:method => 'user.gettopalbums', :user => @username, :page => page, :period => '12month')
      top_albums['topalbums']['album'].each do |album|
        next if album['mbid'].blank?
        album = LastFmApi.get_album(:mbid => album['mbid'])
        next if album['releasedate'] != 2012
        @albums << album
      end
    end
    @albums.pop( @albums.length % 4 )
  end
end
