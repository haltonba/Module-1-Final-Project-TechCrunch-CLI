class CreateRoutesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :routes do |t|
      t.string :name
      t.string :color
      t.string :tfl_id
  end
end
