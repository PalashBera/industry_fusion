class Admin::HomeController < ApplicationController
  before_action :authenticate_resource!
  before_action :authenticate_admin
end
