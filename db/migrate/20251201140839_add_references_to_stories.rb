class AddReferencesToStories < ActiveRecord::Migration[7.1]
  def change
    add_reference :stories, :character, null: false, foreign_key: true
    add_reference :stories, :universes, null: false, foreign_key: true
  end
end
