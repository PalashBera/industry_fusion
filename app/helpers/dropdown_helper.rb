module DropdownHelper
  def month_selection
    [
      %w[January 1], %w[February 2], %w[March 3],
      %w[April 4], %w[May 5], %w[June 6],
      %w[July 7], %w[August 8], %w[September 9],
      %w[October 10], %w[November 11], %w[December 12]
    ]
  end

  def status_selection
    [%w[Active false], %w[Archived true]]
  end

  def indent_item_priority_selection
    IndentItem::PRIORITY_LIST.map { |item| [item.humanize.titleize, item] }
  end

  def reorder_level_priority_selection
    ReorderLevel::PRIORITY_LIST.map { |item| [item.humanize.titleize, item] }
  end
end
