class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :rss
      t.string :url
      t.string :name

      t.timestamps
    end
  end
end
