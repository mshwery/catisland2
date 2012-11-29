class ChangeRawColumnName < ActiveRecord::Migration
  def change
    rename_column :articles, :raw, :original_html
  end
end
