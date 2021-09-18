class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.integer :replier_id
      t.integer :replied_comment_id
      t.text :body

      t.timestamps
    end
  end
end
