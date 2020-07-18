module Exportable
  extend ActiveSupport::Concern

  def export
    @search = model_class.ransack(params[:q])

    if model_class.methods.include?(:included_resources)
      @resources =  @search.result(distinct: true).included_resources
    else
      @resources =  @search.result(distinct: true)
    end

    respond_to do |format|
      format.xlsx do
        render xlsx: "export", filename: "#{controller_name.underscore}_#{I18n.l(Date.today)}.xlsx", xlsx_created_at: Time.now, xlsx_author: current_user.full_name
      end
    end
  end

  private

  def model_class
    controller_name.singularize.classify.constantize
  end
end
