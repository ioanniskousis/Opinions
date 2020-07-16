require 'rails_helper'

RSpec.describe Like, type: :model do
  before :each do
    User.create(username: 'John', fullname: 'John Kennedy')
    User.create(username: 'Eric', fullname: 'Eric Clapton')
    @text = 'The coronavirus pandemic is exposing a central flaw in America’s health care system.'
  end

  it 'creates an opinion and adds 2 likes through likers' do
    user1 = User.first
    user2 = User.last
    Opinion.create(author_id: User.first.id, text: @text)

    Opinion.first.likers.push(user1)
    Opinion.first.likers.push(user2)

    expect(Opinion.first.likes.count).to eq(2)
  end

  it 'checks user::likes_opinion method' do
    user1 = User.first
    user2 = User.last
    Opinion.create(author_id: User.first.id, text: @text)

    user1.likes_opinion(Opinion.first.id)
    user2.likes_opinion(Opinion.first.id)

    expect(Opinion.first.likes.count).to eq(2)
  end

  it 'checks user::unlikes_opinion method' do
    user1 = User.first
    user2 = User.last
    Opinion.create(author_id: User.first.id, text: @text)

    user1.likes_opinion(Opinion.first.id)
    user2.likes_opinion(Opinion.first.id)

    user1.unlikes_opinion(Opinion.first.id)

    expect(Opinion.first.likes.count).to eq(1)
  end
end
