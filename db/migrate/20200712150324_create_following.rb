class CreateFollowing < ActiveRecord::Migration[6.0]
  def change
    create_table :followings do |t|
      t.references :follower, class: :user
      t.references :followed, class: :user
    end
    add_index :followings, [:follower_id, :followed_id], unique: true
  end
end
