class CreateStashes < ActiveRecord::Migration
  def change
    create_table :stashes do |t|
      t.integer :article_id
      t.integer :user_id

      t.timestamps
    end
  end
end
