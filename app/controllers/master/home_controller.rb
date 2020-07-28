class Master::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action { active_sidebar_option(controller_name) }
end
