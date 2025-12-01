class CreateStoryCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :story_characters do |t|
      t.references :story, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end
