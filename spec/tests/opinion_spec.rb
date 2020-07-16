require 'rails_helper'

RSpec.describe Opinion, type: :model do
  before :each do
    User.create(username: 'John', fullname: 'John Kennedy')
    User.create(username: 'Eric', fullname: 'Eric Clapton')
    @text = 'The coronavirus pandemic is exposing a central flaw in America’s health care system.'
  end

  it 'confirms creating an opinion directly' do
    Opinion.create(author_id: User.first.id, text: @text)

    expect(Opinion.all.count).to eq(1)
    expect(Opinion.first.text).to eq(@text)
  end

  it 'confirms user1 creating an opinion' do
    user1 = User.first
    user1.opinions.create(text: @text)

    expect(user1.opinions.count).to eq(1)
    expect(user1.opinions.first.text).to eq(@text)
  end
end
