class Api < ApplicationRecord
    @@base_url = 'https://api.nasa.gov/mars-photos/api/v1/rovers/'
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
                title = "#{rover.titleize} Rover——#{camera}——#{image_data["id"]}"
                if saved_image = Image.find_by(title: title)
                    byebug
                    { 
                        image_url: saved_image.image_url, 
                        title: saved_image.title, 
                        date_of_capture: saved_image.date_of_capture, 
                        like_count: saved_image.like_count,
                        comment_count: saved_image.comment_count
                    }
                else
                    date = Date.parse(image_data["earth_date"])
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
end