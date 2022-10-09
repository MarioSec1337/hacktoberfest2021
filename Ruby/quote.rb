$VERBOSE = nil



require 'net/http'

require 'openssl'

require 'json'



OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE



api_url = 'http://quotes.rest/qod.json'



def format_quote(json_quote)

    json_quote = JSON.parse(json_quote)

    quote = {

        :Title     => json_quote['contents']['quotes'][0]['title'],

        :Quote     => json_quote['contents']['quotes'][0]['quote'],

        :Author    => json_quote['contents']['quotes'][0]['author'],

        :Tags      => json_quote['contents']['quotes'][0]['tags'],

        :Category  => json_quote['contents']['quotes'][0]['category'],

        :Copyright => json_quote['contents']['copyright']

    }

    

    quote.each do |key, value| 

        if key == :Title || key == :Quote

            puts value 

        elsif key == :Tags

            puts "#{key}: #{value.to_a.join(', ')}"

        else

            puts "#{key}: #{value}"

       end

       print "\n" 

    end

end



def get_quote(url, max_request = 5)

  raise "Max number of redirects reached" if max_request <= 0



  response = Net::HTTP.get_response(URI(url))

  case response

  when Net::HTTPSuccess

    format_quote(response.body)

  when Net::HTTPRedirection

    get_quote(URI(response['location']), max_request - 1)

  else

    raise "HTTP Status Code: #{response.code}"

  end

end



get_quote(api_url)

