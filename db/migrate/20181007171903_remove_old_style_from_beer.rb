class RemoveOldStyleFromBeer < ActiveRecord::Migration[5.2]
  def change
    change_table :beers do |t|
      t.remove :old_style
    end
  end
end
