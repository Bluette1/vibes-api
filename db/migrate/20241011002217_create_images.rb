class CreateImages < ActiveRecord::Migration[7.1]
  def change
    create_table :images do |t|
      t.string :title
      t.string :src
      t.string :description
      t.string :category

      t.timestamps
    end
  end
end
