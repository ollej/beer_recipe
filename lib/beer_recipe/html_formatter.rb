class BeerRecipe::HtmlFormatter < BeerRecipe::RecipeFormatter
  def output
    puts parse.read
  end

  def template_path
    'template/html.erb'
  end

end

