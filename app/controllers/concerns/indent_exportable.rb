module IndentExportable
  extend ActiveSupport::Concern

  def export
    @search = IndentItem.ransack(params[:q])
    set_resources

    respond_to do |format|
      format.xlsx do
        render xlsx: "export", filename: "#{controller_name.underscore}_#{I18n.l(Date.today)}.xlsx", xlsx_created_at: Time.now, xlsx_author: current_user.full_name
      end
    end
  end

  private

  def set_resources
    @resources =  @search.result(distinct: true).public_send(scope_method).included_resources
  end
end
