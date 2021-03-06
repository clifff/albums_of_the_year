module ApplicationHelper
  def page_title
    title = "Albums of #{YEAR}"
    if @username
      "#{@username}'s #{title}"
    else
      title
    end
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_text, link_path
    end
  end

  def rdio_link(name)
    link_to "Rdio", "http://www.rdio.com/search/#{URI::escape(name)}/",
      :target => "_blank",
      :onClick => "trackOutboundLink(this, 'Outbound Links', 'Rdio');"
  end

  def spotify_link(name)
    link_to "Spotify", "https://play.spotify.com/search/#{URI::escape(name)}/",
      :target => "_blank",
      :onClick => "trackOutboundLink(this, 'Outbound Links', 'Spotify');"
  end

  def youtube_link(name)
    link_to "YouTube", "http://www.youtube.com/results?search_query=#{URI::escape(name)}",
      :target => "_blank",
      :onClick => "trackOutboundLink(this, 'Outbound Links', 'YouTube');"
  end

  def meta_description
    if @username
      "#{@username}'s most listened to albums from #{YEAR}"
    else
      "Use your Last.fm account to find out what new music you listened to the most in #{YEAR}"
    end
  end

  def proxied_lastfm_image(url)
    uri = URI.parse(url)
    url_for :controller => :images, :action => :lastfm, :cdn_path => uri.path, :only_path => false
  end

end
