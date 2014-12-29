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
      LastFmApi.get_album(mbid: "a50f9ba3-5891-4f22-b5da-edf84cc04b0c"),  # FKA Twigs
      LastFmApi.get_album(mbid: "1e72ba35-fe16-4de8-8a1c-029a4859d114"),  # Caribou - Our Love
      LastFmApi.get_album(mbid: "063f311e-9c81-4616-a007-b76e3df910c9"),  # Run The Jewels 2
      LastFmApi.get_album(mbid: "9ad70837-cea0-4f76-ab3b-75479a2823f6")   # Ty Segall
    ]
  end
end
