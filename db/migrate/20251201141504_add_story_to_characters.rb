class AddStoryToCharacters < ActiveRecord::Migration[7.1]
  def change
    add_reference :characters, :story, null: false, foreign_key: true
  end
end
