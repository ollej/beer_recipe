class BeerRecipe::MashWrapper < BeerRecipe::Wrapper
  attr_reader :steps

  def initialize(record, recipe=nil, steps=nil)
    @record = record
    @recipe = recipe
    @steps = steps
  end
end

