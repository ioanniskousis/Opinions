require 'rails_helper'

RSpec.describe Following, type: :model do
  before :each do
    User.create(username: 'John', fullname: 'John Kennedy')
    User.create(username: 'Eric', fullname: 'Eric Clapton')
  end

  it 'add a following record' do
    user1 = User.first
    user2 = User.last
    Following.create(follower_id: user1.id, followed_id: user2.id)

    expect(user2.followers.count).to eq(1)
    expect(user2.followers.first.username).to eq('John')
    expect(user1.followed.count).to eq(1)
    expect(user1.followed.first.username).to eq('Eric')
    expect(Following.all.count).to eq(1)
  end

  it 'checks user::followers functioning' do
    user1 = User.first
    user2 = User.last
    user1.followers.push(user2)
    expect(user1.followers.count).to eq(1)
    expect(user1.followers.first.username).to eq('Eric')
  end

  it 'checks user::followed functioning' do
    user1 = User.first
    user2 = User.last
    user1.followed.push(user2)
    expect(user1.followed.count).to eq(1)
    expect(user1.followed.first.username).to eq('Eric')
  end

  it 'checks user::follow_user method' do
    user1 = User.first
    user2 = User.last
    user1.follow_user(user2)
    expect(user2.followers.count).to eq(1)
    expect(user2.followers.first.username).to eq('John')
  end

  it 'checks user::unfollow_user method' do
    user1 = User.first
    user2 = User.last
    user1.followed.push(user2)
    expect(user1.followed.count).to eq(1)
    expect(user1.followed.first.username).to eq('Eric')

    user1.unfollow_user(user2)
    expect(user1.followed.count).to eq(0)
  end
end
