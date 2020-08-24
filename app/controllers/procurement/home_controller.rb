class Procurement::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action { active_sidebar_menu_option("procurement") }
end
