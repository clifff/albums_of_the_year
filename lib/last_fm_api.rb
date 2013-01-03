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

  def self.get_album(opts = {})
    opts = last_fm_default_opts(opts)
    opts[:method] = 'album.getinfo'
    url_params = hash_to_url_params(opts)
    json = cache(url_params) do
      conn = new_last_fm_connection
      response = conn.get "/2.0/?#{url_params}"
      body = response.body
      json = JSON.parse(body)['album']
      if json
        #lol processing
        release_date = json['releasedate']
        if release_date.present?
          json['releasedate'] = Time.parse(release_date).year
        else
          Rails.logger.info "OMG GETTING INFO ON #{json['mbid']}"
          doc = Nokogiri::XML( open( "http://musicbrainz.org/ws/2/release/#{json['mbid']}") )
          doc.remove_namespaces!
          date = doc.search("//date").try(:inner_text)
          if date
            json['releasedate'] = date.to_i
          end
          Rails.logger.info "found date of #{date}"
        end
      else
        Rails.logger.error "No album at #{url_params.inspect}"
        json = {}
      end

      JSON.dump(json)
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
