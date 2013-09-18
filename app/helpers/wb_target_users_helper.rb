module WbTargetUsersHelper
  def parse_user_url(url)
    uri = URI.parse(url.to_s.strip.downcase) rescue nil
    if uri and uri.host =~ /\A(www\.|e\.)?weibo\.com\Z/ and match = path_match(uri)
      if /\A\d*\Z/.match(match)
      	wb_id = match
      else
      	domain = match
      end
    else
      wb_id = nil
      domain = nil
    end
    {"wb_id" => wb_id, "domain" => domain}
  end

  def path_match(uri)
    path = uri.path
    path = uri.fragment.to_s.gsub(/\A!\//, "") if path == "/"
    /\A\/u\/(\d*)|\/(\w+)\/profile|([a-z0-9\.\-]+)\Z/.match(path).to_a.select {|e| e}[-1]
  end

  def convert_time_to_js_code(time)
    "Date.UTC(#{time.year}, #{time.month - 1}, #{time.day}, #{time.hour}, #{time.min}, #{time.sec})".js_code
  end
end