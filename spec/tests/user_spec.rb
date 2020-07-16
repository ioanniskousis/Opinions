require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    User.create(username: 'John', fullname: 'John Kennedy')
    User.create(username: 'Eric', fullname: 'Eric Clapton')
  end

  it 'confirms the existene of 2 users' do
    user1 = User.first
    user2 = User.last
    expect(User.all.count).to eq(2)
    expect(user1.username).to eq('John')
    expect(user2.username).to eq('Eric')
  end
end
