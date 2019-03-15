require 'net/http'
require 'uri'
require 'cgi'
require 'json'

module RGinger
  class Parser
    def initialize
    end
  
    def correct(input)

      text = input.dup
      results = {"original" => input, "data" => []}

      if !text || text == ""
        results["corrected" => text]
        return results 
      end

      width = text.length
      escaped = CGI.escape(text)
      url = "#{API_ENDPOINT}?lang=#{DEFAULT_LANG}&clientVersion=#{API_VERSION}&apiKey=#{API_KEY}&text=#{escaped}"

      json_data = get_json(url)["LightGingerTheTextResult"] rescue {}

      unless json_data.empty?
        new_string = text
        json_data.each do |r|
          if r["Mistakes"].size == r["Suggestions"].size
            r["Mistakes"].each_with_index do |m, i|
              from         = m["From"]
              to           = m["To"]
              reverse_from = -(width - from)
              reverse_to   = -(width - to)
              old_item = new_string[reverse_from .. reverse_to]
              new_item = r["Suggestions"][i]["Text"]
              new_string[reverse_from .. reverse_to] = new_item
              results["data"] << {
                "old"          => old_item, 
                "from"         => from, 
                "to"           => to, 
                "reverse_from" => reverse_from, 
                "reverse_to"   => reverse_to,
                "new"          => new_item,
              }
            end    
          else
            from         = r["From"]
            to           = r["To"]
            reverse_from = -(width - from)
            reverse_to   = -(width - to)
            old_item = new_string[reverse_from .. reverse_to]
            new_item = r["Suggestions"][0]["Text"]
            new_string[reverse_from .. reverse_to] = new_item rescue ""
            results["data"] << {
              "old"          => old_item, 
              "from"         => from, 
              "to"           => to, 
              "reverse_from" => reverse_from, 
              "reverse_to"   => reverse_to,
              "new"          => new_item,
            }
          end
          results["corrected"] = new_string
        end
      end
      results
    end
 
    # def rephrase(input)

    #   text = input.dup
    #   results = {"original" => input, "alternatives" => []}
    #   return results if !text || text == ""

    #   width = text.length
    #   escaped = CGI.escape(text)
    #   url = "#{REPHRASE_ENDPOINT}?s=#{escaped}"

    #   json_data = get_json(url)

    #   unless json_data.empty? || json_data["Sentences"].empty?
    #     results["alternatives"] = json_data["Sentences"].map{|s| s["Sentence"]}
    #   end    
    #   results
    # end
    
    :private
    
    def get_json(location, limit = 10)
      raise ArgumentError, 'too many HTTP redirects' if limit == 0
      uri = URI.parse(location)

      begin
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.open_timeout = 5
          http.read_timeout = 10
          http.get(uri.request_uri)
        end
  
        case response
        when Net::HTTPSuccess
          json = response.body
          JSON.parse(json)
        when Net::HTTPRedirection
          location = response['location']
          warn "redirected to #{location}"
          # Recursive method call
          get_json(location, limit - 1)
        else
          # Error
          throw [uri.to_s, response.value].join(" : ")
        end
      rescue => e
        # Error
        throw [uri.to_s, e.class, e].join(" : ")
      end
    end
    
  end  
    
end
