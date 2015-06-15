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

end

