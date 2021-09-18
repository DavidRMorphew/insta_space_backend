class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :title
      t.string :date_of_capture
      t.string :image_url

      t.timestamps
    end
  end
end
