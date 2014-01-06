class PagesController < ApplicationController
  def lastfm_waiting
    @username = params[:username]
    answer = $redis.sismember( LastFmUser.redis_set_key, @username )
    respond_to do |format|
      format.json { render :json => answer }
    end
  end

  def lastfm_bestof
    @username = params[:username]
    if $redis.sismember( LastFmUser.redis_set_key, @username )
      @albums = LastFmUser.top_albums_for_username(@username)
      if @albums.empty?
        render :action => :missing, :status => 404
      else
        @albums.pop( @albums.length % 4 )
        render
      end
    else
      Resque.enqueue(GetLastFmDataResqueJob, @username)
      render :action => :waiting
    end
  end

  def index
    @albums = [
      LastFmApi.get_album(mbid: "cf32c417-73c5-40be-a12d-cde9eb33122b"), # San Fermin
      LastFmApi.get_album(mbid: "4a5a2821-8050-49a1-8a0b-b7f8db6528a4"), # Danny Brown
      LastFmApi.get_album(mbid: "694a93c5-835e-470e-a0d8-e42093eed9af"), # Janelle Monet
      LastFmApi.get_album(mbid: "ebc6e131-2301-480c-ad3f-4e0b790dcf05") # Autre Ne Veut
    ]
  end
end
