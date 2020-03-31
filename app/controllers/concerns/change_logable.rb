module ChangeLogable
  extend ActiveSupport::Concern

  def change_logs
    @resource = controller_name.singularize.classify.constantize.find(params[:id])
    @versions = @resource.versions.reverse
    render "shared/change_logs.js.erb"
  end
end
