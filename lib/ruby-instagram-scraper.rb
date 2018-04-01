require 'open-uri'
require 'json'

module RubyInstagramScraper

  BASE_URL = "https://www.instagram.com"

  def self.search ( query, proxy = nil )
    # return false unless query

    url = add_params("/web/search/topsearch/", {query: query})

    get_json_response(url, proxy)
  end

  def self.get_feed ( username, max_id = nil, proxy = nil )
    url = add_params("/#{ username }/", {__a: 1, max_id: max_id})

    get_json_response(url, proxy)
  end

  def self.get_user_media_nodes ( username, max_id = nil, proxy = nil )
    url = add_params("/#{ username }/", {__a: 1, max_id: max_id})

    get_json_response(url, proxy)["user"]["media"]["nodes"]
  end

  def self.get_user ( username, max_id = nil, proxy = nil )
    url = add_params("/#{ username }/", {__a: 1, max_id: max_id})

    get_json_response(url, proxy)["user"]
  end

  def self.get_top_tag_media_nodes ( tag, max_id = nil, proxy = nil )
    url = add_params("/explore/tags/#{ tag }/", {__a: 1, max_id: max_id})

    get_json_response(url, proxy)['graphql']['hashtag']['edge_hashtag_to_top_posts']['edges'].map { |i| i['node'] }
  end

  def self.get_tag_media_nodes ( tag, max_id = nil, proxy = nil )
    url = add_params("/explore/tags/#{ tag }/", {__a: 1, max_id: max_id})

    get_json_response(url, proxy)['graphql']['hashtag']['edge_hashtag_to_media']['edges'].map { |i| i['node'] }
  end

  def self.get_media ( code, proxy = nil )
    url = add_params("/p/#{ code }/", {__a: 1})
    get_json_response(url, proxy)["graphql"]["shortcode_media"]
  end

  def self.get_media_comments ( code, count = 40, proxy = nil )
    url = add_params("/p/#{ code }/", {__a: 1})
    get_json_response(url, proxy)["graphql"]["shortcode_media"]["edge_media_to_comment"]
  end

  def self.add_params(url, params = {})
    q = ""
    query = ""
    params.each do |key, val|
      q = "?"
      query += "&#{key}=#{val}"
    end
    BASE_URL + url + q + query
  end

  def self.open_with_proxy(url, proxy = nil)
    if proxy && proxy.is_a?(Array) && proxy.count >= 3
      open(url, proxy_http_basic_authentication: proxy[0..2])
    elsif proxy
      open(url, proxy: proxy)
    else
      open(url)
    end
  end

  def self.make_proxy(url, user = nil, password = nil)
    return nil unless url
    proxy_uri = URI.parse(url)
    if user && password
      return [proxy_uri, user, password]
    else
      return proxy_uri
    end
  end

  private

  def self.get_json_response(url, proxy)
    JSON.parse(open_with_proxy(url, proxy).read)
  end
end