class CreateAudios < ActiveRecord::Migration[7.1]
  def change
    create_table :audios do |t|
      t.string :title
      t.string :url
      t.text :description
      t.integer :duration # Duration of the audio in seconds
      t.string :audio_type # Type of audio: background music, guided session, etc.

      t.timestamps
    end
  end
end
