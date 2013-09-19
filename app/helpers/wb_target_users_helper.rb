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

  def set_time_zone
    default = "Beijing"
    Time.zone = (cookies[:tz] || default) rescue default
  end

  def mid_to_url(mid)
    # python code for ref
    # http://qinxuye.me/article/mid-and-url-in-sina-weibo/
    # midint = str(midint)[::-1]
    # size = len(midint) / 7 if len(midint) % 7 == 0 else len(midint) / 7 + 1
    # result = []
    # for i in range(size):
    #     s = midint[i * 7: (i + 1) * 7][::-1]
    #     s = base62_encode(int(s))
    #     s_len = len(s)
    #     if i < size - 1 and len(s) < 4:
    #         s = '0' * (4 - s_len) + s
    #     result.append(s)
    # result.reverse()
    # return ''.join(result)
  end
end