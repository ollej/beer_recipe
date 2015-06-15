class BeerRecipe::Reader
  attr_accessor :parser, :recipe

  def initialize(options = {})
    @options = options
  end

  def read
    @parser ||= NRB::BeerXML::Parser.new
    @beerxml = parser.parse @options[:file]
    self
  end

  def recipe
    BeerRecipe::RecipeWrapper.new(@beerxml.records.first)
  end

  def output
    @options[:formatter].format(recipe)
    self
  end
end

