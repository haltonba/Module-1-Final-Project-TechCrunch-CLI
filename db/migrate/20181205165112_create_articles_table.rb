class CreateArticlesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.string :content
      t.integer :author_id
      t.integer :source_id
    end
  end
end
