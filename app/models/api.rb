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
        if rand(2) == 0
            rover = @@rover_array[rand(3)]
            max_sol = @@rover_max_sol[rover]
            data = self.fetch_rover_images(earth_date = nil, rover, max_sol)
        else
            data = self.fetch_apod_images(earth_date = nil)
        end
        
        if data.count < 50
            data += self.fetch_images
        end
        data.shuffle
    end

    def self.fetch_rover_images(earth_date, rover, max_sol)    
        if earth_date
            date_query = "earth_date=#{earth_date}"
        else
            date_query = "sol=#{rand(max_sol)}"
        end
        url = "#{@@base_url}#{rover}/photos?#{date_query}&api_key=#{ENV["NASA_API_KEY"]}"
        uri = URI(url)
        resp = Net::HTTP.get(uri)
        photos = JSON.parse(resp)
        data = photos["photos"]
        self.format_rover_data(data, rover).compact
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
        self.format_apod_data(data)
    end

    def self.format_rover_data(data, rover)
        data.map do |image_data|
            if image_data["camera"] && image_data["earth_date"]
                camera = @@camera_names[image_data["camera"]["name"]]
                title = "#{rover.titleize} Rover???#{camera}???#{image_data["id"]}"
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
        data.map do |image_data|
            date = image_data["date"]
            title = image_data["title"]
            image_url = image_data["hdurl"] ? image_data["hdurl"] : image_data["url"]
            if saved_image = Image.find_by(title: title)
                ImageSerializer.new(saved_image)
            else
                { 
                    image_url: image_url, 
                    title: title, 
                    date_of_capture: date, 
                    like_count: 0, 
                    comment_count: 0
                }
            end
        end
    end
end