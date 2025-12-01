class CreateStories < ActiveRecord::Migration[7.1]
  def change
    create_table :stories do |t|
      t.string :title
      t.string :content
      t.boolean :public
      t.references :profile, null: false, foreign_key: true

      t.timestamps
    end
  end
end
