class RemoveDirectCharacterAndUniverseFromStories < ActiveRecord::Migration[7.1]
  def change
    # Remove direct foreign keys - use many-to-many join tables instead
    remove_foreign_key :stories, :characters
    remove_column :stories, :character_id, :bigint

    remove_foreign_key :stories, :universes
    remove_column :stories, :universe_id, :bigint
  end
end
