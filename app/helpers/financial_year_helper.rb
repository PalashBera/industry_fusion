module FinancialYearHelper
  def fy_date_range(param_string)
    if param_string.present?
      start_year, end_year = param_string.split("-")
    else
      start_year, end_year = current_financial_year
    end

    [Date.new(start_year.to_i, current_organization.fy_start_month, 1), Date.new(end_year.to_i, current_organization.fy_end_month, 31)]
  end

  def current_financial_year
    current_date = Date.today

    current_date.month < current_organization.fy_start_month ? start_year = current_date.year - 1 : start_year = current_date.year
    current_date.month < current_organization.fy_end_month ? end_year = current_date.year : end_year = current_date.year + 1

    [start_year, end_year]
  end

  def current_organization
    Organization.current_organization
  end
end
