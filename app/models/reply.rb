class Reply < ApplicationRecord
    belongs_to :replier, class_name: "User"
    belongs_to :replied_comment, class_name: "Comment"
end
