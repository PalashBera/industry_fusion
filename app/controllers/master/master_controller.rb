class Master::MasterController < ApplicationController
  before_action :authenticate_user!
end
