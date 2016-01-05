class BeerRecipe::TextFormatter < BeerRecipe::RecipeFormatter
  def format_recipe
    puts "Name: #{@recipe.name}"
    puts "Type: #{@recipe.type}"
    puts "Style: #{@recipe.style.name}"
    puts "Batch size: #{'%.0f' % @recipe.batch_size} L"
    puts "Boil time: #{'%.0f' % @recipe.boil_time} min"
    puts "OG: #{@recipe.og}"
    puts "FG: #{@recipe.fg}"
    puts "ABV: #{'%.2f' % @recipe.abv}%"
    puts "IBU: #{'%.0f' % @recipe.ibu}"
  end

  def format_mash(mash)
    puts "\nMash:"
    puts mash.name
    puts
    format_records(mash.steps, :mashstep)
  end

  def format_mash_step(m)
    puts "#{m.name}\t#{m.type}\t#{'%.2f' % m.infuse_amount} L\t#{m.formatted_step_time}\t#{m.formatted_step_temp}"
  end

  def before_fermentables
    puts "\nFermentables:"
  end

  def format_fermentable(f)
    puts "#{f.formatted_amount}\t #{f.name}"
  end

  def before_hops
    puts "\nHops:"
  end

  def format_hop(h)
    puts "#{h.formatted_amount}\t#{h.name} (#{h.form})\t#{h.use}\t#{h.formatted_time}\t#{h.formatted_ibu}"
  end

  def before_miscs
    puts "\nMiscellaneous:"
  end

  def format_misc(m)
    puts "#{m.name}\t#{m.formatted_amount} #{m.unit}\t#{m.formatted_time} #{m.time_unit}"
  end

  def before_yeasts
    puts "\nYeasts:"
  end

  def format_yeast(y)
    puts "#{y.name}\t#{y.product_id}\t#{y.laboratory}\t#{y.form}"
  end

end
