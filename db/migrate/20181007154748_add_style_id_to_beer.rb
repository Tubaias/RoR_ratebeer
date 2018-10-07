class AddStyleIdToBeer < ActiveRecord::Migration[5.2]
  def change 
    change_table :beers do |t|
      t.integer :style_id
    end
  end
end
