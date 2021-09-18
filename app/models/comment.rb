class Comment < ApplicationRecord
    belongs_to :commenter, class_name: "User"
    belongs_to :commented_image, class_name: "Image"
end
