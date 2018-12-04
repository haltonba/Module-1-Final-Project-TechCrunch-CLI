class CreatePiersTable < ActiveRecord::Migration[5.0]
  def change
    create_table :piers do |t|
      t.string :name
    end
  end
end
