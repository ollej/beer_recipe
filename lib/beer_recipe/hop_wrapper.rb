class BeerRecipe::HopWrapper < BeerRecipe::Wrapper
  attr_accessor :ibu

  def amount
    @record.amount * 1000
  end

  def ibu
    # IBU = (Alfasyrahalt) X (Humlemängd) X (Koktid) X (3) / (Bryggvolym)
    ( @record.alpha * amount * boil_time * 3 ) / @recipe.batch_size
  end

  def boil_time
    if @record.use == 'Dry Hop'
      0
    else
      @record.time / 60
    end
  end

  def formatted_time
    if @record.use == 'Dry Hop'
      "#{'%.0f' % (@record.time / 1440)} days"
    else
      "#{'%.0f' % @record.time} min"
    end
  end

  def formatted_amount
   "#{'%.0f' % amount} gr"
  end

  def formatted_ibu
   "#{'%.2f' % ibu} IBU"
  end

  def amount_percent
    amount / @recipe.total_hops * 100
  end

end

