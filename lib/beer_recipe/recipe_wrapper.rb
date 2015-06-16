class BeerRecipe::RecipeWrapper < BeerRecipe::Wrapper
  SETS = %i(fermentables hops miscs waters yeasts)

  def initialize(record, recipe=nil)
    super
    @sets = {}
  end

  def recipe
    @record
  end

  def get_binding
    binding
  end

  def method_missing(method, *args, &block)
    if SETS.include?(method)
      @sets[method] ||= BeerRecipe::Wrapper.set(recipe, method)
    else
      @record.send(method, *args, &block)
    end
  end

  def respond_to_missing?(name, flag = true)
    SETS.include?(method) || @record.respond_to?(name) || super
  end

  def mash
    @mash ||= BeerRecipe::MashWrapper.new(recipe.mash, self)
  end

  def style_code
    "#{recipe.style.category_number} #{recipe.style.style_letter}"
  end

  def abv
    return @abv if @abv
    og = recipe.og
    fg = recipe.fg
    @abv = if og > 0 && fg > 0
      ( (76.08 * (og - fg) / (1.775 - og) ) * (fg / 0.794) )
    else
      0
    end
  end

  def ibu
    return @ibu if @ibu
    @ibu = 0
    hops.each do |hop|
      @ibu += hop.ibu
    end
    @ibu
  end

  def grains
    fermentables.select { |f| f.type == 'Grain' }
  end

  def color
    color_srm
  end

  def color_mcu
    mcu = 0
    fermentables.each do |f|
      mcu += f.mcu
    end
    mcu
  end

  def color_srm
    # SRM color = 1.4922 * (MCU ** 0.6859)
    mcu = color_mcu
    srm = 1.4922 * (mcu ** 0.6859)
    if srm > 8
      srm
    else
      mcu
    end
  end

  def color_ebc
    color_srm * 1.97
  end

  def color_class
    "srm#{'%.0f' % color}"
  end

  def formatted_color
    "#{'%.0f' % color} °L"
  end

  def total_grains
    total_grains = 0
    fermentables.each do |f|
      total_grains += f.amount
    end
    total_grains
  end

  def total_hops
    hop_weight = 0
    hops.each do |hop|
      hop_weight += hop.amount
    end
    hop_weight
  end

end

