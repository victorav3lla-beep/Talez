class CreateUniverses < ActiveRecord::Migration[7.1]
  def change
    create_table :universes do |t|
      t.string :name
      t.string :image
      t.string :details

      t.timestamps
    end
  end
end
