class BeerRecipe::RecipeWrapper < BeerRecipe::Wrapper
  def recipe
    @record
  end

  def fermentables
    wrap_set(recipe.fermentables)
  end

  def hops
    wrap_set(recipe.hops)
  end

  def miscs
    wrap_set(recipe.miscs)
  end

  def waters
    wrap_set(recipe.waters)
  end

  def yeasts
    wrap_set(recipe.yeasts)
  end

  def mash
    BeerRecipe::MashWrapper.new(recipe.mash, self, wrap_set(recipe.mash.mash_steps))
  end

  def abv
    og = recipe.og
    fg = recipe.fg
    if og > 0 && fg > 0
      ( (76.08 * (og - fg) / (1.775 - og) ) * (fg / 0.794) )
    else
      0
    end
  end

  def ibu
    ibu = 0
    hops.each do |hop|
      ibu += hop.ibu
    end
    ibu
  end

  def wrap_set(set)
    set.map { |record| wrap(record) }
  end

  def wrap(record)
    wrapper = "#{record.record_type.capitalize}Wrapper".to_sym
    begin
      return BeerRecipe.const_get(wrapper).new(record, self)
    rescue NameError
      return BeerRecipe::Wrapper.new(record, self)
    end
  end

end

