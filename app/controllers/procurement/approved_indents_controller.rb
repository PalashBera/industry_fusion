require "auth"

class Procurement::ApprovedIndentsController < Procurement::HomeController
  layout "print", only: :print

  skip_before_action :authenticate_user!, only: %i[email_approval email_rejection]

  def index
    @search = IndentItem.joins(:indent).ransack(params[:q])
    indent_items = @search.result.approved
    @total_count = indent_items.count
    @bordered_item_ids = indent_items.group_by(&:indent_id).map { |_k, v| v.last.id }
    @pagy, @indent_items = pagy_countless(indent_items.included_resources, link_extra: 'data-remote="true"')
  end

  def show
    indent
  end

  def print
    indent
  end

  private

  def indent
    @indent ||= Indent.find(params[:id])
  end
end
