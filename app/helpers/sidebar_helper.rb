module SidebarHelper
  def draw_side_bar
    case @direction
    when 'root', 'users'
      render 'followings/to_follow'
    when 'user'
      render 'users/sidebar_user'
    end
  end
end
