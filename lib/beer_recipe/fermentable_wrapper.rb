class BeerRecipe::FermentableWrapper < BeerRecipe::Wrapper
  def formatted_amount
    "#{'%.2f' % amount} kg"
  end

  def formatted_color
    "#{'%.0f' % color_ebc} EBC"
  end

  def color_ebc
    color
  end

  def color_srm
    @color_srm ||= BeerRecipe::Formula.new.ebc_to_srm(color_ebc)
  end

  def srm_in_batch
    BeerRecipe::Formula.new.mcu_to_srm(mcu)
  end

  def mcu
    @mcu ||= BeerRecipe::Formula.new.mcu(amount, color_srm, @recipe.batch_size)
  end

  def color_class
    c = color_srm.to_i
    if c > 40
      'srm-max'
    elsif c < 1
      'srm-min'
    else
      "srm#{c}"
    end
  end

  def color_hex
    "#%02x%02x%02x" % BeerRecipe::Formula.new.srm_to_rgb(color_srm)
  end

  def amount_percent
    amount / @recipe.total_grains * 100
  end

end

