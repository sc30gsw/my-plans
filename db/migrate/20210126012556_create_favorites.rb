class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :user, foreign_key: true
      t.references :note, foreign_key: true

      t.timestamps
      t.index %i[user_id note_id], unique: true
    end
  end
end
