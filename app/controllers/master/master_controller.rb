class Master::MasterController < ApplicationController
  before_action :authenticate_user!
  before_action :check_organization_presence
end
