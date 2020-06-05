class Master::HomeController < ApplicationController
  before_action :authenticate_user!, :check_organization_presence
end
