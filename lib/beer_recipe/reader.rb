class BeerRecipe::Reader
  attr_accessor :parser, :recipe

  def initialize(options = {})
    @options = options
    @options[:recipe_wrapper] ||= BeerRecipe::RecipeWrapper
    @options[:formatter] ||= BeerRecipe::HtmlFormatter
  end

  def self.parse_options(options)
    opts = {}
    opts[:formatter] = if options.fetch('--format', 'html').downcase.start_with? 't'
      BeerRecipe::TextFormatter
    else
      BeerRecipe::HtmlFormatter
    end
    opts[:template] = options['--template'] if options['--template']
    opts[:file] = options['--file'] if options['--file']
    opts
  end

  def read
    @parser ||= NRB::BeerXML::Parser.new
    @beerxml = @parser.parse @options.fetch(:file, STDIN)
    self
  end

  def parse
    raise BeerRecipe::ParseError if @beerxml.nil?
    @beerxml.records.each do |record|
      recipe = @options[:recipe_wrapper].new(record)
      begin
        @options[:formatter].new(@options).format(recipe).output
      rescue NoMethodError => e
        raise BeerRecipe::FormatError.new e
      end
    end
  end
end

