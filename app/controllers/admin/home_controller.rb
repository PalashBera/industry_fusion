class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :check_organization_presence
end
