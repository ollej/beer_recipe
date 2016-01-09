class BeerRecipe::Mash_stepWrapper < BeerRecipe::Wrapper
  def step_temp
    super || 0
  end

  def ramp_time
    super || 0
  end

  def step_time
    super || 0
  end

  def infuse_amount
    super || 0
  end

  def formatted_step_temp
    "#{'%.0f' % step_temp}"
  end

  def formatted_ramp_time
    "#{'%.0f' % ramp_time}"
  end

  def formatted_step_time
    "#{'%.0f' % step_time}"
  end

  def formatted_infuse_amount
    "#{'%.2f' % infuse_amount}"
  end
end

