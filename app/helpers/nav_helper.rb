module NavHelper
  def draw_nav_bar
    render 'layouts/nav'
  end

  def draw_currentuserinfo
    render('layouts/currentuserinfo') if @current_user
  end

  def link_to_current_user
    return unless @current_user

    label = 'profile'
    path = user_path(@current_user)
    cond = ((@direction == 'user' || @direction == 'edit_user') && (@user == @current_user))
    nav_class = cond ? 'nav-item nav-selected' : 'nav-item'
    image = images_store + 'guest-w.png'

    tag.div(link_to(path, class: 'nav-item-link') do
      [image_tag(image, class: 'nav-item-image', alt: ''), tag.label(label, class: 'nav-item-label')].join.html_safe
    end, class: nav_class)
  end

  def link_to_logout
    return unless @current_user

    label = 'logout'
    path = session_path(0)
    nav_class = 'nav-item'
    image = images_store + 'logout.png'

    tag.div(link_to(path, method: :delete, class: 'nav-item-link') do
      [image_tag(image, class: 'nav-item-image', alt: ''), tag.label(label, class: 'nav-item-label')].join.html_safe
    end, class: nav_class)
  end

  def link_to_home
    return unless @current_user

    label = 'Home'
    path = opinions_path
    nav_class = (@direction == 'root' ? 'nav-item nav-selected' : 'nav-item')
    image = images_store + 'home.png'

    tag.div(link_to(path, class: 'nav-item-link') do
      [image_tag(image, class: 'nav-item-image', alt: ''), tag.label(label, class: 'nav-item-label')].join.html_safe
    end, class: nav_class)
  end

  def link_to_users
    return unless @current_user

    label = 'Users'
    path = users_path
    nav_class = (@direction == 'users' ? 'nav-item nav-selected' : 'nav-item')
    image = images_store + 'users.png'

    tag.div(link_to(path, class: 'nav-item-link') do
      [image_tag(image, class: 'nav-item-image', alt: ''), tag.label(label, class: 'nav-item-label')].join.html_safe
    end, class: nav_class)
  end

  def link_to_signin
    return if @current_user

    label = 'Log In'
    path = new_session_path
    nav_class = @direction == 'new_session' ? 'nav-item nav-selected' : 'nav-item'
    image = images_store + 'login.png'

    tag.div(link_to(path, class: 'nav-item-link') do
      [image_tag(image, class: 'nav-item-image', alt: ''), tag.label(label, class: 'nav-item-label')].join.html_safe
    end, class: nav_class)
  end

  def link_to_signup
    return if @current_user

    label = 'Sign Up'
    path = new_user_path
    nav_class = (@direction == 'new_user' ? 'nav-item nav-selected' : 'nav-item')
    image = images_store + 'add-user.png'

    tag.div(link_to(path, class: 'nav-item-link') do
      [image_tag(image, class: 'nav-item-image', alt: ''), tag.label(label, class: 'nav-item-label')].join.html_safe
    end, class: nav_class)
  end
end
