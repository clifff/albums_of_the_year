class ImagesController < ApplicationController
  def lastfm
    resp = Faraday.get("http://userserve-ak.last.fm/" + params[:cdn_path])
    if resp.status == 200
      response.headers['Cache-Control'] = 'max-age=315576000,public'
      send_data resp.body, :type => resp.headers['content-type'], :disposition => 'inline'
    else
      head 404
    end
  end
end
