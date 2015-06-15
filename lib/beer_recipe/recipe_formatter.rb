class BeerRecipe::RecipeFormatter
  def format(recipe)
    @recipe = recipe
    format_recipe
    %i(fermentables hops miscs waters yeasts).map do |set|
      format_records(@recipe.send(set), set)
    end
    format_mash(@recipe.mash)
  end

  def format_recipe
    puts "Name: #{@recipe.name}"
    puts "Type: #{@recipe.type}"
    puts "Style: #{@recipe.style.name}"
    puts "Batch size: #{'%.0f' % @recipe.batch_size} L"
    puts "Boil time: #{'%.0f' % @recipe.boil_time} min"
    puts "OG: #{@recipe.og}"
    puts "FG: #{@recipe.fg}"
    puts "ABV: #{'%.2f' % @recipe.abv}%"
    puts "IBU: #{@recipe.ibu}"
  end

  def format_mash(mash)
    puts "\nMash:"
    puts mash.name
    puts
    format_records(mash.steps, :mashstep)
  end

  def format_mashstep(m)
    puts "#{m.name}\t#{m.type}\t#{'%.2f' % m.infuse_amount} L\t#{m.formatted_step_time}\t#{m.formatted_step_temp}"
  end

  def format_records(records, set)
    if records.size > 0
      send("before_#{set}") if respond_to? "before_#{set}"
      records.each do |record|
        if respond_to? record.format_method
          send(record.format_method, record)
        end
      end
      send("after_#{set}") if respond_to? "after_#{set}"
    end
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
    #puts "#{h.name} (#{h.form}) α#{h.alpha}% β#{h.beta}% #{h.use} #{h.time} min #{'%.0f' % amount} gr"
    puts "#{h.formatted_amount}\t#{h.name} (#{h.form})\t#{h.use}\t#{h.formatted_time}\t#{h.formatted_ibu}"
  end

  def before_yeasts
    puts "\nYeasts:"
  end

  def format_yeast(y)
    puts "#{y.name}\t#{y.product_id}\t#{y.laboratory}\t#{y.form}"
  end
end

