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
      @sets[method] ||= BeerRecipe::Wrapper.set(self, recipe.send(method))
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

  def has_final_values?
    og > 0 && fg > 0 && abv > 0
  end

  def file_name
    I18n.transliterate(name.downcase.gsub(/\s+/, '_')).gsub(/[^a-z0-9_]/, '')
  end

  def style_code
    "#{recipe.style.category_number} #{recipe.style.style_letter}"
  end

  def abv
    @abv ||= BeerRecipe::Formula.new.sg_to_abv(recipe.og, recipe.fg)
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
    @color_srm ||= BeerRecipe::Formula.new.mcu_to_srm(color_mcu)
  end

  def color_ebc
    @color_eb ||= BeerRecipe::Formula.new.srm_to_ebc(color_srm)
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

  def formatted_color
    "#{'%.0f' % color_ebc} EBC"
  end

  def total_grains
    return @total_grains if @total_grains
    @total_grains = 0
    fermentables.each do |f|
      @total_grains += f.amount
    end
    @total_grains
  end

  def total_hops
    return @hop_weight if @hop_weight
    @hop_weight = 0
    hops.each do |hop|
      @hop_weight += hop.amount
    end
    @hop_weight
  end

  def total_time
    boil_time + mash.total_mash_time
  end

  def total_time_period
    "PT#{'%0.f' % total_time}M"
  end

  def boil_time_period
    "PT#{'%0.f' % boil_time}M"
  end

  def serving_size
    1000
  end

  # Returns calories per liter
  def calories
    @calories ||= if has_final_values?
      BeerRecipe::Formula.new.calories(serving_size, abv, og, fg)
    else
      0
    end
  end

  def real_extract
    @real_extract ||= BeerRecipe::Formula.new.real_extract(og, fg)
  end
end

