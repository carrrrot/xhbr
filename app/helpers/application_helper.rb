module ApplicationHelper
  def logged_in?
    cookies[:logged_in] == PASSWORD
  end
end
