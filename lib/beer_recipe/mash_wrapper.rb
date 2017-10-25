class BeerRecipe::MashWrapper < BeerRecipe::Wrapper

  def initialize(record, recipe=nil)
    @record = record
    @recipe = recipe
  end

  def steps
    return [] if @record.nil?
    @steps ||= @record.mash_steps.map do |step|
      BeerRecipe::Wrapper.wrap(step, @recipe)
    end
  end

  def total_mash_time
    return 0 if steps.empty?
    steps.map { |s| s.step_time || 0 }.reduce :+ || 0
  end
end

