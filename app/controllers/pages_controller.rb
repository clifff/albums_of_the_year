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
end
