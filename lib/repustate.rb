#
# Repustate Ruby API client.
#
# Requirements:
#  - Ruby >= 1.8.7
#  - json
#
# Want to change it / improve it / share it? Go for it.
#
# Feedback is appreciated at info@repustate.com
#
# More documentation available at http://www.repustate.com/docs
#

require 'base64'
require 'cgi'
require 'net/http'

require 'rubygems'
require 'json'

class Repustate

  def initialize(key, version='v2')
    @key = key
    @version = version
  end

  # Retrieve the sentiment for a single URl or block of text. Optionally select
  # a language other than English.
  def sentiment(options={:text => nil, :url => nil, :lang => 'en'})
    call_api('score', options)
  end

  # Bulk score multiple pieces of text (not urls!).
  def bulk_sentiment(options={:items => [], :lang => 'en'})
    items_to_score = Hash[options[:items].enum_for(:each_with_index).collect {
                            |val, i| ["text#{i}", val]
                          }]
    items_to_score["lang"] = options[:lang]
    call_api('bulk-score', items_to_score)
  end

  # Clean up a web page. It doesn't work well on home pages - it's
  # designed for content pages.
  def clean_html(options={:url => nil})
    use_http_get = true
    call_api('clean-html', options, use_http_get)
  end
  
  def nouns(options={:cloud => nil, :text => nil, :url => nil, :lang => 'en'})
    call_natural_language('noun', options)
  end

  def adjectives(options={:cloud => nil, :text => nil, :url => nil, :lang => 'en'})
    call_natural_language('adj', options)
  end

  def verbs(options={:cloud => nil, :text => nil, :url => nil, :lang => 'en'})
    call_natural_language('verb', options)
  end

  def ngrams(options={
               :url => nil,
               :text => nil,
               :max => nil,
               :min => nil,
               :freq => nil,
               :stopwords => nil,
               :lang => 'en'
             })
    use_http_get = (options[:text] == nil or options[:text].empty?)
    call_api('ngrams', options, use_http_get)
  end

  # Convert english date indicators like "today", "tomorrow", "next week"
  # into date strings like 2011-01-12.
  def date_extraction(options={:text => nil})
    call_api('extract-dates', options)
  end

  # Given a list of images and titles, generate a simple powerpoint
  # presentation.
  def powerpoint(options={
                  :title => '',
                  :author => '',
                  :images => [],
                  :titles => [],
                  :notes => [],
                })
    args = {
      :title => options[:report_title],
      :author => options[:author],
    }

    images_and_titles = options[:images].zip(options[:titles], options[:notes])
    images_and_titles.each_with_index do |value, i|
      
      filename = value[0]
      title = value[1]
      notes = value[2]

      image_data = File.read(filename)
      encoded_image = Base64.encode64(image_data)
      args["slide_#{i}_image"] = encoded_image
      args["slide_#{i}_title"] = title
      args["slide_#{i}_notes"] = notes
    end

    call_api('powerpoint', args)
  end

  protected

  def url_for_call(api_function)
    if api_function == 'powerpoint'
      return "http://api.repustate.com/#{@version}/#{@key}/powerpoint/"
    else
      return "http://api.repustate.com/#{@version}/#{@key}/#{api_function}.json"
    end
  end

  def get_http_result(url, args, use_http_get)
    if use_http_get
      query = args.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')
      url = url.concat("?#{query}")
      result = Net::HTTP.get_response(URI.parse(url))
    else
      result = Net::HTTP.post_form(URI.parse(url), args)
    end

    if result.code != '200'
      raise "HTTP Error: #{result.code} #{result.body}"
    end

    result.body
  end

  def parse_result(result, api_function)
    if api_function == 'powerpoint'
      return result
    else
      # Default is JSON
      return JSON.parse(result)
    end
  end

  def call_api(api_function, args={}, use_http_get=false)
    # Avoid sending empty parameters
    args = args.select { |key, value| value and not value.empty? }

    url = url_for_call(api_function)
    result = get_http_result(url, args, use_http_get)
    parse_result(result, api_function)
  end

  def call_natural_language(api_function, args={
                            :cloud => nil,
                            :text => nil,
                            :url => nil,
                            })
    call_api(api_function, args)
  end

end
