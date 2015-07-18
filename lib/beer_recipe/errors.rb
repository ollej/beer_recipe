module BeerRecipe
  class BeerRecipeError < StandardError; end
  class ParseError < BeerRecipeError; end
  class FormatError < BeerRecipeError; end
  class NotImplentedError < BeerRecipeError; end
end
