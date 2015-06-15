class BeerRecipe::YeastWrapper < BeerRecipe::Wrapper
  def formatted_attenuation
   "#{'%.0f' % attenuation}%"
  end

  def formatted_temperatures
    "#{'%.0f' % min_temperature}°C - #{'%.0f' % max_temperature}°C"
  end
end


