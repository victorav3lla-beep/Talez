class FixCharactersAndUniversesSchema < ActiveRecord::Migration[7.1]
  def change
    # Remove circular dependencies
    remove_foreign_key :characters, :stories
    remove_column :characters, :story_id, :bigint

    remove_foreign_key :universes, :stories
    remove_column :universes, :story_id, :bigint

    # Add profile_id to characters (nullable for default TALEZ characters)
    add_reference :characters, :profile, foreign_key: true, null: true
    add_column :characters, :is_custom, :boolean, default: false, null: false

    # Add profile_id to universes (nullable for default TALEZ universes)
    add_reference :universes, :profile, foreign_key: true, null: true
    add_column :universes, :is_custom, :boolean, default: false, null: false

    # Rename stories.universes_id to universe_id
    rename_column :stories, :universes_id, :universe_id

    # Add missing columns to stories
    add_column :stories, :status, :string, default: "draft", null: false
    add_column :stories, :likes_count, :integer, default: 0, null: false

    # Rename details to description for consistency
    rename_column :characters, :details, :description
    rename_column :universes, :details, :description

    # Rename image to image_url for clarity
    rename_column :characters, :image, :image_url
    rename_column :universes, :image, :image_url
  end
end
