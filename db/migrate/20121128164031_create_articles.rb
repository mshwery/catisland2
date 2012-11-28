class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :source_id
      t.text :body
      t.text :raw

      t.timestamps
    end
  end
end
