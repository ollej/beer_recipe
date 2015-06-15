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

  def record_type
    @record.class.to_s.gsub(/^.*::/, '').downcase
  end

  def format_method
    "format_#{record_type}".to_sym
  end
end

