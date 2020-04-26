module UsersHelper
  def user_status(user)
    user_role = user.user_role

    case user_role
    when "admin"
      '<span class="badge badge-danger" title="Admin">Admin</span>'.html_safe
    when "general_user"
      '<span class="badge badge-success" title="General User">General User</span>'.html_safe
    else
      '<span class="badge badge-secondary" title="Pending">Pending</span>'.html_safe
    end
  end
end
