class CreateFavorites < ActiveRecord::Migration[7.2]
  def change
    create_table :favorites do |t|
      t.string :symbol

      t.timestamps
    end
  end
end
