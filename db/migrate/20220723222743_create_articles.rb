class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :url_to_image
      t.timestamp :published_at

      t.timestamps
    end
  end
end
