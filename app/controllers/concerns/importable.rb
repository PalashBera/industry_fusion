module Importable
  extend ActiveSupport::Concern

  def import
    controller_name.singularize.classify.constantize.import(params[:file])
    redirect_to url_for(controller: controller_name, action: "index"), flash: { success: "#{controller_name.humanize} have been successfully imported." }
  end
end
