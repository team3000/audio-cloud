class CreateMediaStreams < ActiveRecord::Migration
  def change
    create_table :media_streams do |t|
      t.string :name
      t.string :detail
      t.string :permalink_url
      t.string :url
      t.string :download_url
      t.string :image_url
      t.integer :media_type
      t.integer :duration
      t.integer :likes

      t.timestamps
    end
  end
end
