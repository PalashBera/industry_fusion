class Admin::HomeController < ApplicationController
  before_action :authenticate_user!, :authenticate_admin
  before_action { active_sidebar_option(controller_name) }
end
