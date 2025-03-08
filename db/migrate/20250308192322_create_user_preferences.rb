class CreateUserPreferences < ActiveRecord::Migration[7.1]
  def change
    create_table :user_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.float :volume
      t.string :selected_track
      t.integer :image_transition_interval

      t.timestamps
    end
  end
end
