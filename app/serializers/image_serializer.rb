class ImageSerializer < ActiveModel::Serializer
  attributes :id, :image_url, :title, :date_of_capture, :like_count, :comment_count, :current_user_like
end
