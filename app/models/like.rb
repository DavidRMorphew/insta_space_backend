class Like < ApplicationRecord
    belongs_to :liker, class_name: "User"
    belongs_to :liked_image, class_name: "Image"
end
