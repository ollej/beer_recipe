class BeerRecipe::RecipeFormatter
  def format(recipe)
    @recipe = recipe
    self
  end

  def template_path
    ''
  end

  def template
    IO.read(template_path)
  end

  def parse
    erb = ERB.new(template).result(@recipe.get_binding)
    StringIO.new(erb)
  end

  def output
    format_recipe
    BeerRecipe::RecipeWrapper::SETS.map do |set|
      format_records(@recipe.send(set), set)
    end
    format_mash(@recipe.mash)
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

end

