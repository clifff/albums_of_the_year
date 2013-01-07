module ApplicationHelper
  def page_title
    title = "Albums of 2012"
    if @username
      "#{@username}'s #{title}"
    else
      title
    end
  end
end
