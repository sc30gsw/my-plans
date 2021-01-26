class CreateMemos < ActiveRecord::Migration[6.0]
  def change
    create_table :memos do |t|
      t.text :content, null: false
      t.boolean :checked
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
