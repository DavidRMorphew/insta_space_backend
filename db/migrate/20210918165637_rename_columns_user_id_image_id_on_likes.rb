class RenameColumnsUserIdImageIdOnLikes < ActiveRecord::Migration[6.0]
  def change
    rename_column :likes, :user_id, :liker_id
    rename_column :likes, :image_id, :liked_image_id
  end
end
