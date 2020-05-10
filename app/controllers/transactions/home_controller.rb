class Transactions::HomeController < ApplicationController
  before_action :authenticate_resource!
end
