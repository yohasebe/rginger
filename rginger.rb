require 'net/http'
require 'uri'
require 'json'

GINGER_API_ENDPOINT = 'http://services.gingersoftware.com/Ginger/correct/json/GingerTheText'
GINGER_REPHRASE_ENDPOINT = 'http://ro.gingersoftware.com/rephrase/rephrase'
GINGER_API_VERSION  = '2.0'
GINGER_API_KEY      = '6ae0c3a0-afdc-4532-a810-82ded0054236'
DEFAULT_LANG        = 'US'

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
      puts [uri.to_s, response.value].join(" : ")
    end
  rescue => e
    # Error
    puts [uri.to_s, e.class, e].join(" : ")
  end
end

puts "# => ORIGINAL"
puts original = "I am suffring from a desease, amn't I"
width = original.length
corrected = []

text = URI.escape(original)

correction = "#{GINGER_API_ENDPOINT}?lang=#{DEFAULT_LANG}&clientVersion=#{GINGER_API_VERSION}&apiKey=#{GINGER_API_KEY}&text=#{text}"

results = get_json(correction)["LightGingerTheTextResult"]

if results.empty?
  puts "# No need to correct"
  a_better = original
else
  new_string = original
  results.each do |r|
    if r["Mistakes"].size == r["Suggestions"].size
      r["Mistakes"].each_with_index do |m, i|
        from = -(width - m["From"])
        to   = -(width - m["To"])
        new_string[from .. to] = r["Suggestions"][i]["Text"]
      end    
    else
      from = -(width - r["From"])
      to   = -(width - r["To"])
      new_string[from .. to] = r["Suggestions"][0]["Text"] rescue ""
    end
  end
  puts "# => CORRECTED"
  puts a_better = new_string
end

text = URI.escape(a_better)

rephrase = "#{GINGER_REPHRASE_ENDPOINT}?s=#{text}"
results = get_json(rephrase)

if results.empty? || results["Sentences"].empty?
  puts "# No alternative expressions"
else
  puts "# => ALTERNATIVES"
  results["Sentences"].each do |item|
    puts item["Sentence"]
  end
end
