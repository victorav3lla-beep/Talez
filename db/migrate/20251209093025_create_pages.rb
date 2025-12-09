class CreatePages < ActiveRecord::Migration[7.1]
  def change
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.integer :position
      t.references :story, null: false, foreign_key: true

      t.timestamps
    end
  end
end
