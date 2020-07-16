class CreateLike < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :opinion, foreign_key: true
    end
    add_index :likes, [:user_id, :opinion_id], unique: true
  end
end
