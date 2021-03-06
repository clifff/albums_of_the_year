require 'open-uri'

class LastFmApi

  def self.get(opts = {})
    opts = last_fm_default_opts(opts)
    url_params = hash_to_url_params(opts)
    json = cache(url_params) do
      conn = new_last_fm_connection
      response = conn.get "/2.0/?#{url_params}"
      response.body
    end
    JSON.parse(json)
  end

  def self.get_top_albums(opts = {})
    opts = last_fm_default_opts(opts)
    opts[:method] = 'user.gettopalbums'
    url_params = hash_to_url_params(opts)
    top_albums = cache(url_params) do
      conn = new_last_fm_connection
      response = conn.get "/2.0/?#{url_params}"
      json = JSON.parse(response.body)

      if json['error'] == 6
        JSON.dump([])
      else
        # If only zero or one album is returned, its not an array.
        # We really want an array, so...
        json['topalbums']['album'] = [json['topalbums']['album']].flatten.compact

        albums = json['topalbums']['album'].
          select{ |album| album && album['mbid'].present? }.
          map{ |album| album['mbid']}
        JSON.dump(albums)
      end
    end
    JSON.parse(top_albums)
  end

  def self.get_album(opts = {})
    opts = last_fm_default_opts(opts)
    opts[:method] = 'album.getinfo'
    url_params = hash_to_url_params(opts)
    json = cache(url_params) do
      conn = new_last_fm_connection
      response = conn.get "/2.0/?#{url_params}"
      body = response.body
      if body.strip.empty? || body.strip == '""'
        JSON.dump({})
      else
        json = JSON.parse(body)['album']
        if json
          #lol processing
          release_date = json['releasedate']
          if release_date.present?
            json['releasedate'] = Time.parse(release_date).year
          else
            Rails.logger.info "OMG GETTING INFO ON #{json['mbid']}"
            resp = Faraday.get "http://musicbrainz.org/ws/2/release/#{json['mbid']}"
            doc = Nokogiri::XML(resp.body)
            doc.remove_namespaces!
            date = doc.search("//date")[0].try(:inner_text)
            if date
              # Maybe the date is just the year
              if date.length == 4
                json['releasedate'] = date.to_i
              elsif date.length == 7
                # maybe like 2008-11
                json['releasedate'] = Date.strptime(date, "%Y-%m").year
              else
                # Or maybe its like 2012-06-05
                json['releasedate'] = Date.strptime(date, "%Y-%m-%d").year
              end
            end
            Rails.logger.info "found date of #{json['releasedate']}"
          end
        else
          Rails.logger.error "No album at #{url_params.inspect}"
          json = {}
        end
        ['wiki', 'listeners', 'tracks', 'toptags'].each do |field|
          json.delete(field)
        end
        JSON.dump(json)
      end
    end
    JSON.parse(json)
  end

  private

  def self.hash_to_url_params(hash)
    components = []
    hash.each do |key, value|
      components << "#{key}=#{value}"
    end
    components.join("&")
  end

  def self.cache(key)
    result = $redis.get(key)
    if result.nil?
      result = yield
      $redis.set(key, result)
      $redis.expire(key, 1.week)
    end
    Rails.logger.info result.inspect
    result
  end

  def self.new_last_fm_connection
    root = "http://ws.audioscrobbler.com/"
    conn = Faraday.new(:url => root) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
    conn
  end

  def self.last_fm_default_opts(opts = {})
    opts.reverse_merge!({
      :format => 'json',
      :api_key => '96d4752540fd5d1f07bbed8b8ec57636'
    })
  end

end
