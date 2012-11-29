class RenameBodyToEditedBody < ActiveRecord::Migration
  def change
    rename_column :articles, :body, :edited_body
  end
end
