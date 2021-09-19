class Api < ApplicationRecord
    @@base_url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/'
    @@rover_array = ["curiosity", "spirit", "opportunity"]
    @@camera_names = {
        "FHAZ" => "Front Hazard Avoidance Camera",
        "RHAZ" => "Rear Hazard Avoidance Camera",
        "MAST" => "Mast Camera",
        "CHEMCAM" => "Chemistry and Camera Complex",
        "MAHLI" => "Mars Hand Lens Imager",
        "MARDI" => "Mars Descent Imager",
        "NAVCAM" => "Navigation Camera",
        "PANCAM" => "Panoramic Camera",
        "MINITES" => "Miniature Thermal Emission Spectrometer"
    }

    def self.fetch_images(earth_date = nil)
        if earth_date
            date_query = "earth_date=#{earth_date}"
        else
            date_query = "sol=#{rand(5100)}"
        end

        # randomize rover
        rover = @@rover_array[rand(2)]
        # Set data parameters to actual dates for opportunity rover in earth_date
        url = "#{@@base_url}#{rover}/photos?#{date_query}&api_key=#{ENV["NASA_API_KEY"]}"
        uri = URI(url)
        resp = Net::HTTP.get(uri)
        photos = JSON.parse(resp)
        data = photos["photos"]
        # get more data if insufficient for frontend display
        data = self.format_data(data, rover).compact
        if data.count < 15
            data += self.fetch_images
        end
        data.shuffle
    end

    def self.format_data(data, rover)
        data.map do |image_data|
            if image_data["camera"] && image_data["earth_date"]
                camera = @@camera_names[image_data["camera"]["name"]]
                date = Date.parse(image_data["earth_date"])
                { image_url: image_data["img_src"], title: "#{rover.titleize} Rover——#{camera}——#{image_data["id"]}", date_of_capture: date }
            end
        end
    end

end