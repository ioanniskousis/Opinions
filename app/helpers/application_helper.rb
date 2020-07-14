module ApplicationHelper
  def link_to_unfollow(user)
    cond = @current_user.followed.include?(user) && (@current_user != user)
    path = following_path(user)
    link_to 'Unfollow', path, method: :delete, class: 'g-link m30' if cond
  end

  def link_to_follow(user)
    cond = @current_user.followed.include?(user) || (@current_user == user)
    path = followings_path(user: user, view: @user_view, direction: @direction, view_user: user)
    link_to('Follow', path, method: :post, class: 'g-link m30') unless cond
  end

  def to_follow_button(user)
    plus_image = images_store + 'plus.png'
    if @current_user.followed.include?(user) || (@current_user == user)
      tag.div(class: 'plus half_opacity') do
        tag.div do
          image_tag(plus_image, alt: '', class: 'half_size')
        end
      end
    else
      tag.div(class: 'plus') do
        path = followings_path(user: user, view: @user_view, direction: @direction, view_user: @user)
        link_to(image_tag(plus_image, alt: '', class: 'half_size'), path, method: :post)
      end
    end
  end

  def user_image_link_xlarge(user)
    guest_image = images_store + 'guest-128.png'
    if user.photo_blob
      image_tag(user.photo_blob, alt: '')
    else
      image_tag(guest_image, alt: '')
    end
  end

  def draw_header
    render 'layouts/header'
  end

  def following_arrow(user)
    follower_image = images_store + 'follower.png'
    image_tag(follower_image, alt: '') if @current_user_followees.include?(user.id)
  end

  def follower_arrow(user)
    follow_image = images_store + 'follow.png'
    image_tag(follow_image, alt: '') if @current_user_followers.include?(user.id)
  end

  def images_store
    'https://storage.googleapis.com/opinions-bucket/images/'
  end
end
