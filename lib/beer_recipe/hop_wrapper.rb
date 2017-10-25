class BeerRecipe::HopWrapper < BeerRecipe::Wrapper

  def amount
    if @record.amount < 1
      @record.amount * 1000
    else
      @record.amount
    end
  end

  def aau
    @record.alpha * amount * 0.035274
  end

  # mg/l of added alpha acids
  def mgl_added_alpha_acids
    BeerRecipe::Formula.new.mgl_added_alpha_acids(@recipe.batch_size, @record.alpha, amount)
  end

  def ibu
    @ibu ||= calculate_ibu
  end

  def calculate_ibu
    # TODO: Use recipe boil time for first wort/mash
    # TODO: Use calculated_og if og missing.
    if has_needed_ibu_values? && contributes_bitterness?
      ibu = BeerRecipe::Formula.new.tinseth(@recipe.batch_size, @record.time, @recipe.og, @record.alpha, amount)
      ibu = adjust_bitterness(ibu)
      ibu
    else
      0
    end
  end

  def adjust_bitterness(ibu)
    if @record.form == 'Pellet'
      ibu *= 1.10
    elsif @record.form == 'Plug'
      ibu *= 1.02
    end
    if @record.use == 'Mash'
      ibu *= 0.20
    elsif @record.use == 'First Wort'
      ibu *= 1.10
    elsif @record.use == 'Aroma'
      ibu *= 0.50
    end
    ibu
  end

  def contributes_bitterness?
    !dryhop?
  end

  def has_needed_ibu_values?
    @recipe.has_final_values? && @recipe.batch_size > 0 && amount > 0 && @record.time > 0
  end

  def dryhop?
    @record.use == 'Dry Hop' || @record.time > 320
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

