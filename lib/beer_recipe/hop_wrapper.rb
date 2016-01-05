class BeerRecipe::HopWrapper < BeerRecipe::Wrapper

  def amount
    @record.amount * 1000
  end

  def aau
    @record.alpha * amount * 0.035274
  end

  # mg/l of added alpha acids
  def mgl_added_alpha_acids
    BeerRecipe::Formula.new.mgl_added_alpha_acids(@recipe.batch_size, @record.alpha, amount)
  end

  def ibu
    @ibu ||= BeerRecipe::Formula.new.tinseth(@recipe.batch_size, @record.time, @recipe.og, @record.alpha, amount)
  end

  def dryhop?
    @record.use == 'Dry Hop'
  end

  def boil_time
    if dryhop?
      0
    else
      @record.time / 60
    end
  end

  def formatted_time
    if dryhop?
      "#{'%.0f' % (@record.time / 1440)}"
    else
      "#{'%.0f' % @record.time}"
    end
  end

  def time_unit
    if dryhop?
      'days'
    else
      'min'
    end
  end

  def formatted_amount
   "#{'%.0f' % amount}"
  end

  def formatted_ibu
   "#{'%.1f' % ibu}"
  end

  def amount_percent
    amount / @recipe.total_hops * 100
  end

end

