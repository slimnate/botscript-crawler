module ScriptsHelper
  def split_price(price)
    prices = price.split(' - ')
    prices[1] = prices[1].gsub(' every ', '/') unless prices[1] == nil
    return prices
  end

  def base_price_class(base_price)
    result = "price-base "
    result += base_price == "Free" ? "text-success" : "text-danger"
    return result
  end
end
