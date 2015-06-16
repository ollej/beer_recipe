class BeerRecipe::HtmlFormatter < BeerRecipe::RecipeFormatter
  def output
    puts parse.read
  end

  def template_file
    'html.erb'
  end

end

