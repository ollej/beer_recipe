class BeerRecipe::Wrapper
  def initialize(record, recipe=nil)
    @record = record
    @recipe = recipe
  end

  def method_missing(method, *args, &block)
    @record.send(method, *args, &block)
  end

  def respond_to_missing?(name, flag = true)
    @record.respond_to?(name) || super
  end

  def format_method
    "format_#{record_type}".to_sym
  end

  def blank?(obj)
    obj.nil? || (obj.respond_to?(:empty?) && obj.empty?)
  end

  def self.set(recipe, set)
    set.map { |record| self.wrap(record, recipe) }
  end

  def self.wrap(record, recipe)
    wrapper = "#{record.record_type.capitalize}Wrapper".to_sym
    begin
      return BeerRecipe.const_get(wrapper).new(record, recipe)
    rescue NameError
      return self.new(record, recipe)
    end
  end
end

