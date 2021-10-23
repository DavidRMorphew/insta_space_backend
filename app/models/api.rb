class Api < ApplicationRecord
    @@base_url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/'
    @@base_apod_url = "https://api.nasa.gov/planetary/apod?"
    @@rover_array = ["curiosity", "spirit", "opportunity"]
    @@rover_max_sol = {"curiosity" => 3241, "spirit" => 2208, "opportunity" => 5111}
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
        image_fetch_type = 1 #rand(2)

        if image_fetch_type == 0
            # randomize rover
            rover = @@rover_array[rand(3)]
            max_sol = @@rover_max_sol[rover]
            photo_data = self.fetch_rover_images(earth_date = nil, rover, max_sol)
            data = self.format_rover_data(photo_data, rover).compact
        else
            photo_data = self.fetch_apod_images(earth_date = nil)
            data = self.format_apod_data(photo_data)
        end
        
        if data.count < 15
            data += self.fetch_images
        end
        data.shuffle
    end

    def self.fetch_rover_images(earth_date, rover, max_sol)
        # randomize rover
        rover = @@rover_array[rand(2)]
        max_sol = @@rover_max_sol[rover]
        
        if earth_date
            date_query = "earth_date=#{earth_date}"
        else
            date_query = "sol=#{rand(max_sol)}"
        end

        # Set data parameters to actual dates for opportunity rover in earth_date
        url = "#{@@base_url}#{rover}/photos?#{date_query}&api_key=#{ENV["NASA_API_KEY"]}"
        uri = URI(url)
        resp = Net::HTTP.get(uri)
        photos = JSON.parse(resp)
        data = photos["photos"]
    end

    def self.fetch_apod_images(earth_date)
        if earth_date
            url = "#{@@base_apod_url}api_key=#{ENV["NASA_API_KEY"]}&date=#{earth_date}"
        else
            url = "#{@@base_apod_url}api_key=#{ENV["NASA_API_KEY"]}&count=25"
        end
        uri = URI(url)
        resp = Net::HTTP.get(uri)
        data = JSON.parse(resp)
    end

    def self.format_rover_data(data, rover)
        data.map do |image_data|
            if image_data["camera"] && image_data["earth_date"]
                camera = @@camera_names[image_data["camera"]["name"]]
                title = "#{rover.titleize} Rover—#{camera}—#{image_data["id"]}"
                if saved_image = Image.find_by(title: title)
                    ImageSerializer.new(saved_image)
                else
                    date = image_data["earth_date"]
                    { 
                        image_url: image_data["img_src"], 
                        title: title, 
                        date_of_capture: date, 
                        like_count: 0, 
                        comment_count: 0
                    }
                end
            end
        end
    end

    def self.format_apod_data(data)
        puts data
    end
end