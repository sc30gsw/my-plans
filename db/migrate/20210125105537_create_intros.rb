class CreateIntros < ActiveRecord::Migration[6.0]
  def change
    create_table :intros do |t|
      t.string :first_name
      t.string :last_name
      t.string :website
      t.text :profile
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
