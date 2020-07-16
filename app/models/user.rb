class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :fullname, presence: true

  asat = 'ActiveStorage::Attachment'
  has_one_attached :photo
  pho = 'photo'
  has_one :user_photo, -> { where(name: pho) }, class_name: asat, as: :record, inverse_of: :record, dependent: false
  has_one :photo_blob, through: :user_photo, class_name: 'ActiveStorage::Blob', source: :blob

  has_one_attached :coverimage
  cim = 'coverimage'
  has_one :user_cover, -> { where(name: cim) }, class_name: asat, as: :record, inverse_of: :record, dependent: false
  has_one :cover_blob, through: :user_cover, class_name: 'ActiveStorage::Blob', source: :blob

  has_many :opinions, foreign_key: 'author_id', dependent: :destroy

  has_many :followings, foreign_key: 'followed_id', dependent: :destroy
  has_many :inverse_followings, class_name: 'Following', foreign_key: 'follower_id', dependent: :destroy

  has_many :followers, class_name: 'User', through: :followings, foreign_key: 'follower_id'
  has_many :followed, class_name: 'User', through: :inverse_followings, foreign_key: 'followed_id'

  has_many :likes, dependent: :destroy

  def self.user_followed(user)
    user.followed.pluck(:followed_id) << 0
  end

  def self.popular_matrix
    find_by_sql("SELECT users.id, count(followings.id) AS cnt
                 FROM users LEFT JOIN followings ON users.id = followings.followed_id
                 GROUP BY users.id")
  end

  def self.friendly_matrix
    find_by_sql("SELECT users.id, count(followings.id) AS cnt
                 FROM users LEFT JOIN followings ON users.id = followings.follower_id
                 GROUP BY users.id")
  end

  def self.opinions_matrix
    find_by_sql("SELECT users.id, count(opinions.id) AS cnt
                 FROM users LEFT JOIN opinions ON users.id = opinions.author_id
                 GROUP BY users.id")
  end

  def follow_user(user)
    followed.push(user)
  end

  def unfollow_user(user)
    followed.delete(user)
  end

  def likes_opinion(opinion)
    l = Like.new(user_id: id, opinion_id: opinion)
    l.save
  end

  def unlikes_opinion(opinion)
    like = Like.find_by(user_id: id, opinion_id: opinion)
    like&.destroy unless like.nil?
  end

  def user_followers_count(arr)
    rec = arr.filter { |f| f.id == id }
    return rec[0].cnt if rec

    0
  end

  def user_followees_count(arr)
    rec = arr.filter { |f| f.id == id }
    return rec[0].cnt if rec

    0
  end

  def user_opinions_count(arr)
    rec = arr.filter { |f| f.id == id }
    return rec[0].cnt if rec

    0
  end
end
