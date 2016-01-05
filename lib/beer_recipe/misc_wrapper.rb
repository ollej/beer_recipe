class BeerRecipe::MiscWrapper < BeerRecipe::Wrapper
  DAY = 1440

  def weight?
    amount_is_weight
  end

  def days?
    time > DAY
  end

  def large_amount?
    amount >= 1
  end

  def unit
    # maybe use display_amount directly instead
    if weight?
      large_amount? ? 'kilograms' : 'grams'
    else
      large_amount? ? 'items' : 'ml'
    end
  end

  def formatted_amount
    if large_amount?
      "#{'%.0f' % amount}"
    else
      "#{'%.0f' % (1000 * amount)}"
    end
  end

  def formatted_time
    t = if days?
      "#{'%.0f' % (time / DAY)}"
    else
      "#{'%.0f' % time}"
    end
  end

  def time_unit
    if days?
      'days'
    else
      'minutes'
    end
  end
end

