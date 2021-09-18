class Comment < ApplicationRecord
    belongs_to :commenter, class_name: "User"
    belongs_to :commented_image, class_name: "Image"
    has_many :replies, foreign_key: :replied_comment_id
    has_many :repliers, through: :replies, source: :replier
end
