class BeerRecipe::FermentableWrapper < BeerRecipe::Wrapper
  def formatted_amount
    "#{'%.2f' % amount} kg"
  end

    #@type="Grain", @yield=82.5, @color=5.91,
  def formatted_color
    "#{'%.0f' % color} EBC"
  end

  def color_ebc
    color
  end

  def color_srm
    color / 1.97
  end

  def color_class
    "srm#{'%.0f' % color_srm}"
  end

  def mcu
    # MCU = (weight kg * lovibond * 2.205) / (volume * 0.264)
    (amount * color_srm * 2.205) / (@recipe.batch_size * 0.264)
  end
end

