class User < ApplicationRecord
    has_secure_password
    has_many :likes
    has_many :images, through: :likes
    has_many :comments
    has_many :images, through: :comments
end
