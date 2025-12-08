class ConvertStoryContentToPages < ActiveRecord::Migration[7.0]
  def up
    Story.find_each do |story|
      next if story.content.blank? || story.pages.exists?

      story.pages.create(
        title: story.title,
        content: story.content,
        position: 1
      )
    end
  end

  def down
    Page.destroy_all
  end
end
