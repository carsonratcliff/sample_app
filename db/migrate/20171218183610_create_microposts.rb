class CreateMicroposts < ActiveRecord::Migration[5.2]
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    # 13.3 - Micropost migration with added user_id index
    add_index :microposts, [:user_id, :created_at]
  end
end
