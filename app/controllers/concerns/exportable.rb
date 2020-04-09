module Exportable
  extend ActiveSupport::Concern

  def export
    @resources =  controller_name.singularize.classify.constantize.all

    respond_to do |format|
      format.xlsx do
        render xlsx: "export",
               filename: "#{controller_name.underscore}_#{I18n.l(Date.today)}.xlsx",
               xlsx_created_at: Time.now,
               xlsx_author: current_user.full_name
      end
    end
  end
end
