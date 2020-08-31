class Admin::HomeController < ApplicationController
  before_action :authenticate_user!, :authenticate_admin
  before_action { active_sidebar_menu_option("admin") }
  before_action { active_sidebar_sub_menu_option(controller_name) }
end
