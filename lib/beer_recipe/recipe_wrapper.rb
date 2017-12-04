class BeerRecipe::RecipeWrapper < BeerRecipe::Wrapper
  SETS = %i(fermentables hops miscs waters yeasts)

  def initialize(record, actual_values: false)
    super(record)
    @actual_values = actual_values
    @sets = {}
  end

  def recipe
    @record
  end

  def date
    recipe.date || nil
  end

  def get_binding
    binding
  end

  def method_missing(method, *args, &block)
    if SETS.include?(method)
      @sets[method] ||= BeerRecipe::Wrapper.set(self, recipe.send(method))
    else
      recipe.send(method, *args, &block)
    end
  end

  def respond_to_missing?(name, flag = true)
    SETS.include?(method) || recipe.respond_to?(name) || super
  end

  def mash
    @mash ||= BeerRecipe::MashWrapper.new(recipe.mash, self) unless recipe.mash.nil?
  end

  def file_name
    I18n.transliterate(name.downcase.gsub(/\s+/, '_')).gsub(/[^a-z0-9_]/, '')
  end

  def has_final_values?
    og > 0 && fg > 0 && abv > 0
  end

  def style_code
    return "" if recipe.style.nil? || !recipe.style.respond_to?(:category_number) ||
      !recipe.style.respond_to?(:style_letter)
    "#{recipe.style.category_number} #{recipe.style.style_letter}"
  end

  def batch_size
    recipe.batch_size || 0
  end

  def gallons
    batch_size * 0.264172
  end

  def estimated_og
    strip_unit(recipe.est_og)
  end

  def estimated_fg
    strip_unit(recipe.est_fg)
  end

  def actual_og
    recipe.og
  end

  def actual_fg
    recipe.fg
  end

  def og
    @og ||= @actual_values && actual_og > 0 ? actual_og : estimated_og || actual_og || 0
  end

  def fg
    @fg ||= @actual_values && actual_fg > 0 ? actual_fg : estimated_fg || actual_fg || 0
  end

  def actual_abv
    strip_unit(recipe.abv)
  end

  def estimated_abv
    strip_unit(recipe.est_abv)
  end

  def calculated_abv
    BeerRecipe::Formula.new.sg_to_abv(og, fg)
  end

  def abv
    @abv ||= @actual_values && actual_abv > 0 ? actual_abv : estimated_abv || calculated_abv
  end

  def ibu
    @ibu ||= @actual_values && calculated_ibu > 0 ? calculated_ibu : estimated_ibu || calculated_ibu
  end

  def strip_unit(value)
    return value if value.nil? || !value.kind_of?(String)
    value.gsub(/ \w+\Z/, '').to_f
  end

  def estimated_ibu
    strip_unit(recipe.ibu)
  end

  def calculated_ibu
    @calculated_ibu ||= begin
      ibu = 0
      hops.each do |hop|
        ibu += hop.ibu
      end
      bitter_extracts.each do |f|
        ibu += f.ibu
      end
      ibu
    end
  end

  def grains
    fermentables.select { |f| f.type == 'Grain' }
  end

  def bitter_extracts
    fermentables.select { |f| f.bitter_extract? }
  end

  def estimated_color
    strip_unit(recipe.est_color)
  end

  def color
    @actual_values ? actual_color : estimated_color
  end

  def actual_color
    color_ebc
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
    @color_ebc ||= BeerRecipe::Formula.new.srm_to_ebc(color_srm)
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
    "#{'%.0f' % color} EBC"
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

  def boil_time
    recipe.boil_time || 0
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
    @calories ||= @actual_values && calculated_calories > 0 ? calculated_calories : estimated_calories
  end

  def estimated_calories
    strip_unit(recipe.calories)
  end

  def calculated_calories
    if has_final_values?
      BeerRecipe::Formula.new.calories(serving_size, abv, og, fg)
    else
      0
    end
  end

  def real_extract
    @real_extract ||= if has_final_values?
      BeerRecipe::Formula.new.real_extract(og, fg)
    else
      0
    end
  end
end

