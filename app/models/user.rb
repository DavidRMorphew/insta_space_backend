class User < ApplicationRecord
    has_secure_password
    has_many :likes, foreign_key: :liker_id
    has_many :liked_images, through: :likes, source: :liked_image
    has_many :comments, foreign_key: :commenter_id
    has_many :commented_images, through: :comments, source: :commented_image
    has_many :replies, foreign_key: :replier_id
    has_many :replied_comments, through: :replies, source: :replied_comment

    validates :username, :email, uniqueness: {case_sensitive: false}
    before_validation :downcase_email

    private

    def downcase_email
        self.email = self.email.downcase
    end
end