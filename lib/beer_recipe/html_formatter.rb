class BeerRecipe::HtmlFormatter < BeerRecipe::RecipeFormatter
  def output
    puts parse.read
  end

  def template_file
    @options.fetch(:template, template_path('html.erb'))
  end

end

