class BeerRecipe::Mash_stepWrapper < BeerRecipe::Wrapper
  def formatted_step_temp
    "#{'%.0f' % step_temp}°C"
  end

  def formatted_ramp_time
    "#{'%.0f' % ramp_time} min"
  end

  def formatted_step_time
    "#{'%.0f' % step_time} min"
  end

  def formatted_infuse_amount
    "#{'%.2f' % infuse_amount} L"
  end
end

