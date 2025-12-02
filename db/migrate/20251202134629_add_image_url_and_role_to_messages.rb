class AddImageUrlAndRoleToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :image_url, :string
    add_column :messages, :role, :string
  end
end
