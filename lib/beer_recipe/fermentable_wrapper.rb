class BeerRecipe::FermentableWrapper < BeerRecipe::Wrapper
  def formatted_amount
    "#{'%.2f' % @record.amount} kg"
  end
end

