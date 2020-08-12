# DelayedJobWeb.use Rack::Auth::Basic do |username, password|
#   # authenticate
#   user = User.find_by_username(username)
#   return false unless user.authenticate(password)
#
#   # authorize. I am using cancancan for authorization. You can use any other authorization gem you see fit.
#   ability = Ability.new(user)
#   can = ability.can? :manage, Delayed::Job
#   raise CanCan::AccessDenied unless can
#   true
# end
