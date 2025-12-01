class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :image
      t.string :details

      t.timestamps
    end
  end
end
