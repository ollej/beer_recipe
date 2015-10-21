class BeerRecipe::MiscWrapper < BeerRecipe::Wrapper
  def unit
    if amount_is_weight
      'grams'
    else
      'ml'
    end
  end

  def formatted_amount
    "#{'%.1f' % (1000 * amount)}"
  end

  def formatted_time
    t = if time > 1440
      "#{'%.0f' % (time / 1440)}"
    else
      "#{'%.0f' % time}"
    end
  end

  def time_unit
    if time > 1440
      'days'
    else
      'minutes'
    end
  end
end

