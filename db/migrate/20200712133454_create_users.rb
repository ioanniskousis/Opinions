class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, null: false, unique: true
      t.string :fullname, null: false
      t.string :photo
      t.string :coverImage

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
