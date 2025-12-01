class CreateStoryUniverses < ActiveRecord::Migration[7.1]
  def change
    create_table :story_universes do |t|
      t.references :story, null: false, foreign_key: true
      t.references :universe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
