class CreateIndices < ActiveRecord::Migration
  def change
    create_table :indices do |t|
      t.string :zip

      t.timestamps null: false
    end
  end
end
