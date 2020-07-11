class Procurement::HomeController < ApplicationController
  before_action :authenticate_user!
end
