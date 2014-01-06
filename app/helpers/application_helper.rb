module ApplicationHelper
  def page_title
    title = "Albums of 2013"
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
    link_to "Rdio", "http://www.rdio.com/search/#{URI::escape(name)}/", :target => "_blank" 
  end

  def spotify_link(name)
    link_to "Spotify", "https://play.spotify.com/search/#{URI::escape(name)}/", :target => "_blank" 
  end

  def youtube_link(name)
    link_to "YouTube", "http://www.youtube.com/results?search_query=#{URI::escape(name)}", :target => "_blank"
  end
end
