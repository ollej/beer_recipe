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

  def output
    @options[:formatter].format(BeerRecipe::RecipeWrapper.new(@beerxml.records.first)).output
  end
end

