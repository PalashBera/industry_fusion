class Master::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action { active_sidebar_menu_option("master") }
  before_action { active_sidebar_sub_menu_option(controller_name) }
end
