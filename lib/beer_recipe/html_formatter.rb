class BeerRecipe::HtmlFormatter < BeerRecipe::RecipeFormatter
  def output
    puts parse.read
  end

  def template
    IO.read('template/html.erb')
  end

  def parse
    erb = ERB.new(template).result(@recipe.get_binding)
    StringIO.new(erb)
  end
end

