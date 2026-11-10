module ApplicationHelper
  def sar(amount)
    number_to_currency(amount, unit: "SAR", format: "%n %u")
  end
end
