module FinancialYearHelper
  def fy_date_range
    if params[:fy].present?
      start_year, end_year = params[:fy].split("-")
    else
      start_year, end_year = current_financial_year
    end

    [Date.new(start_year.to_i, 4, 1), Date.new(end_year.to_i, 3, 31)]
  end

  def current_financial_year
    current_date = Date.today
    current_date.month < 4 ? start_year = current_date.year - 1 : start_year = current_date.year
    current_date.month < 4 ? end_year = current_date.year : end_year = current_date.year + 1
    [start_year, end_year]
  end
end
