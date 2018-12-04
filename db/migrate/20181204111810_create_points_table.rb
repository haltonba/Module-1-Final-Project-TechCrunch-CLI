class CreatePointsTable < ActiveRecord::Migration[5.0]
  def change
    create_table :points do |t|
      t.string :name
      t.string :pier
      t.string :route
      t.integer :no_of_points
  end
end
