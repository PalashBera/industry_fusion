module UsersHelper
  def user_status(user)
    if user.admin?
      '<span class="badge badge-success" title="Active">Active</span>'
    elsif user.archive?
      '<span class="badge badge-danger" title="Archived">Archived</span>'
    elsif user.pending_acception?
      '<span class="badge badge-warning" title="Pending">Pending</span>'
    else
      '<span class="badge badge-success" title="Active">Active</span>'
    end
  end

  def user_role(user)
    if user.admin?
      '<span class="badge badge-danger" title="Admin">Admin</span>'
    else
      '<span class="badge badge-primary" title="General User">General User</span>'
    end
  end
end
