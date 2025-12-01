class AddStoryToUniverses < ActiveRecord::Migration[7.1]
  def change
    add_reference :universes, :story, null: false, foreign_key: true
  end
end
