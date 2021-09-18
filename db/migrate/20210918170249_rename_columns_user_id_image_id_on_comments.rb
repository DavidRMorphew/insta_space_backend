class RenameColumnsUserIdImageIdOnComments < ActiveRecord::Migration[6.0]
  def change
    rename_column :comments, :user_id, :commenter_id
    rename_column :comments, :image_id, :commented_image_id
  end
end
