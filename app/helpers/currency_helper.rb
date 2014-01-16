module CurrencyHelper
  def dollars(amount)
    number_to_currency(amount, :precision => 0)
  end

  def dollars_and_cents(amount)
    number_to_currency(amount)
  end
end
