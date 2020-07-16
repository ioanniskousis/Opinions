module UsersHelper
  def draw_users_main_menu
    all_class = @user_view == 'all' ? 'main-menu-item selected' : 'main-menu-item'
    friendly_class = @user_view == 'friendly' ? 'main-menu-item selected' : 'main-menu-item'
    popular_class = @user_view == 'popular' ? 'main-menu-item selected' : 'main-menu-item'
    protagonists_class = @user_view == 'protagonists' ? 'main-menu-item selected' : 'main-menu-item'
    buttons = []
    buttons << tag.div(link_to('all', users_path(view: 'all')), class: all_class)
    buttons << tag.div(link_to('most friendly', users_path(view: 'friendly')), class: friendly_class)
    buttons << tag.div(link_to('most popular', users_path(view: 'popular')), class: popular_class)
    buttons << tag.div(link_to('protagonists', users_path(view: 'protagonists')), class: protagonists_class)
    tag.div(class: 'main-menu') do
      buttons.join.html_safe
    end
  end

  def draw_user_main_menu
    details_class = @user_view == 'details' ? 'main-menu-item selected' : 'main-menu-item'
    opinions_class = @user_view == 'opinions' ? 'main-menu-item selected' : 'main-menu-item'
    following_class = @user_view == 'following' ? 'main-menu-item selected' : 'main-menu-item'
    followers_class = @user_view == 'followers' ? 'main-menu-item selected' : 'main-menu-item flr'

    buttons = []
    buttons << tag.div(link_to('details', user_path(@user, view: 'details')), class: details_class)
    buttons << tag.div(link_to('opinions', user_path(@user, view: 'opinions')), class: opinions_class)
    buttons << tag.div(link_to('following', user_path(@user, view: 'following')), class: following_class)
    buttons << tag.div(link_to('followers', user_path(@user, view: 'followers')), class: followers_class)
    tag.div(class: 'main-menu') do
      buttons.join.html_safe
    end
  end

  def draw_user_page
    case @user_view
    when 'opinions'
      render 'opinions'
    when 'following'
      @users_list = @followings
      @users_list_caption = @followings.count.to_s + ' Followed Users'
      render 'layouts/users_list'
    when 'followers'
      @users_list = @followers
      @users_list_caption = @followers.count.to_s + ' Followers'
      render 'layouts/users_list'
    else
      render 'details'
    end
  end

  def link_to_edit_user
    link_to('Edit', edit_user_path(@user), class: 'g-link m30') if @user == @current_user
  end

  def user_image(user)
    return user.photo_blob if user.photo_blob

    images_store + 'guest-128.png'
  end

  def user_coverimage(user)
    return user.cover_blob if user.cover_blob

    images_store + 'default-cover.jpeg'
  end

  def user_image_link_large(user)
    if user.photo_blob
      tag.div(link_to(user_path(user), class: 'image') do
        image_tag(user.photo_blob, class: 'nav-item-image full_size', alt: '')
      end)
    else
      guest_image = images_store + 'guest-128.png'
      tag.div(link_to(user_path(user), class: 'image') do
        image_tag(guest_image, class: 'nav-item-image half_size', alt: '')
      end)
    end
  end

  def user_followers_count(followers, user)
    rec = followers.filter { |f| f.id == user.id }
    return rec[0].cnt if rec

    0
  end

  def user_followees_count(followees, user)
    rec = followees.filter { |f| f.id == user.id }
    return rec[0].cnt if rec

    0
  end

  def user_opinions_count(opinions, user)
    rec = opinions.filter { |f| f.id == user.id }
    return rec[0].cnt if rec

    0
  end
end
