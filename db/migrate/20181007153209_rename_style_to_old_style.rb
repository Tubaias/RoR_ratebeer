class RenameStyleToOldStyle < ActiveRecord::Migration[5.2]
  def change
    rename_column :beers, :style, :old_style
  end
end
