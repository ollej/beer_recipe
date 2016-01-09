class BeerRecipe::YeastWrapper < BeerRecipe::Wrapper
  def formatted_attenuation
    return "" if blank?(attenuation)
   "#{'%.0f' % attenuation}%"
  end

  def formatted_temperatures
    return "" if blank?(min_temperature) || blank?(max_temperature)
    "#{'%.0f' % min_temperature}°C - #{'%.0f' % max_temperature}°C"
  end
end


