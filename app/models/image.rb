class Image < ApplicationRecord
    has_many :likes, foreign_key: :liked_image_id
    has_many :likers, through: :likes, source: :liker
    has_many :comments, foreign_key: :commented_image_id
    has_many :commenters, through: :comments, source: :commenter

    def like_count
        self.likes.count
    end

    def comment_count
        self.comments.count
    end
end