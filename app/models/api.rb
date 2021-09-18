class Api < ApplicationRecord
    @@base_url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/opportunity/photos?'

    def self.fetch_images(earth_date = nil)
        if earth_date
            date_query = "earth_date=#{earth_date}"
        else
            date_query = "sol=#{rand(5100)}"
        end
        # Set data parameters to actual dates for opportunity rover in earth_date
        url = "#{@@base_url}#{date_query}&camera=PANCAM&api_key=#{ENV["NASA_API_KEY"]}"
        uri = URI(url)
        resp = Net::HTTP.get(uri)
        photos = JSON.parse(resp)
        data = photos["photos"]
        # get more data if insufficient for frontend display
        if data.count < 15
            data += self.fetch_images
        end
        data
    end

end