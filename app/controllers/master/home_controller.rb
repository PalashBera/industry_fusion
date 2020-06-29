class Master::HomeController < ApplicationController
  before_action :authenticate_user!
end
