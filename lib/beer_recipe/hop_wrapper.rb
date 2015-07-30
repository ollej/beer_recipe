class BeerRecipe::HopWrapper < BeerRecipe::Wrapper
  attr_accessor :ibu

  def amount
    @record.amount * 1000
  end

  def ibu
    # IBU = (Alfasyrahalt) X (Humlemängd) X (Koktid) X (3) / (Bryggvolym)
    ( @record.alpha * amount * boil_time * 3 ) / @recipe.batch_size
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

