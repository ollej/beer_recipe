require 'nrb/beerxml'

class RecipeReader
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
    @options[:formatter].format(RecipeWrapper.new(@beerxml.records.first))
  end
end

class Wrapper
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

class RecipeWrapper < Wrapper
  def recipe
    @record
  end

  def fermentables
    wrap_set(recipe.fermentables)
  end

  def hops
    wrap_set(recipe.hops)
  end

  def miscs
    wrap_set(recipe.miscs)
  end

  def waters
    wrap_set(recipe.waters)
  end

  def yeasts
    wrap_set(recipe.yeasts)
  end

  def mash
    MashWrapper.new(recipe.mash, self, wrap_set(recipe.mash.mash_steps))
  end

  def abv
    og = recipe.og
    fg = recipe.fg
    if og > 0 && fg > 0
      ( (76.08 * (og - fg) / (1.775 - og) ) * (fg / 0.794) )
    else
      0
    end
  end

  def ibu
    ibu = 0
    hops.each do |hop|
      ibu += hop.ibu
    end
    ibu
  end

  def wrap_set(set)
    set.map { |record| wrap(record) }
  end

  def wrap(record)
    wrapper = "#{record.record_type.capitalize}Wrapper".to_sym
    begin
      return Object.const_get(wrapper).new(record, self)
    rescue NameError
      return Wrapper.new(record, self)
    end
  end

end

class MashWrapper < Wrapper
  attr_reader :steps

  def initialize(record, recipe=nil, steps=nil)
    @record = record
    @recipe = recipe
    @steps = steps
  end
end

class Mash_stepWrapper < Wrapper
  def formatted_step_temp
    "#{'%.0f' % step_temp}°C"
  end

  def formatted_step_time
    "#{'%.0f' % step_time} min"
  end
end

class HopWrapper < Wrapper
  attr_accessor :ibu

  def amount
    @record.amount * 1000
  end

  def ibu
    # IBU = (Alfasyrahalt) X (Humlemängd) X (Koktid) X (3) / (Bryggvolym)
    ( @record.alpha * amount * boil_time * 3 ) / @recipe.batch_size
  end

  def boil_time
    if @record.use == 'Dry Hop'
      0
    else
      @record.time / 60
    end
  end

  def formatted_time
    if @record.use == 'Dry Hop'
      "#{'%.0f' % (@record.time / 1440)} days"
    else
      "#{'%.0f' % @record.time} min"
    end
  end

  def formatted_amount
   "#{'%.0f' % amount} gr"
  end

  def formatted_ibu
   "#{'%.2f' % ibu} IBU"
  end
end

class FermentableWrapper < Wrapper
  def formatted_amount
    "#{'%.2f' % @record.amount} kg"
  end
end

class RecipeFormatter
  def format(recipe)
    @recipe = recipe
    format_recipe
    %i(fermentables hops miscs waters yeasts).map do |set|
      format_records(@recipe.send(set), set)
    end
    format_mash(@recipe.mash)
  end

  def format_recipe
    puts "Name: #{@recipe.name}"
    puts "Type: #{@recipe.type}"
    puts "Style: #{@recipe.style.name}"
    puts "Batch size: #{'%.0f' % @recipe.batch_size} L"
    puts "Boil time: #{'%.0f' % @recipe.boil_time} min"
    puts "OG: #{@recipe.og}"
    puts "FG: #{@recipe.fg}"
    puts "ABV: #{'%.2f' % @recipe.abv}%"
    puts "IBU: #{@recipe.ibu}"
  end

  def format_mash(mash)
    puts "\nMash:"
    puts mash.name
    puts
    format_records(mash.steps, :mashstep)
  end

  def format_mashstep(m)
    puts "#{m.name}\t#{m.type}\t#{'%.2f' % m.infuse_amount} L\t#{m.formatted_step_time}\t#{m.formatted_step_temp}"
  end

  def format_records(records, set)
    if records.size > 0
      send("before_#{set}") if respond_to? "before_#{set}"
      records.each do |record|
        if respond_to? record.format_method
          send(record.format_method, record)
        end
      end
      send("after_#{set}") if respond_to? "after_#{set}"
    end
  end

  def before_fermentables
    puts "\nFermentables:"
  end

  def format_fermentable(f)
    puts "#{f.formatted_amount}\t #{f.name}"
  end

  def before_hops
    puts "\nHops:"
  end

  def format_hop(h)
    #puts "#{h.name} (#{h.form}) α#{h.alpha}% β#{h.beta}% #{h.use} #{h.time} min #{'%.0f' % amount} gr"
    puts "#{h.formatted_amount}\t#{h.name} (#{h.form})\t#{h.use}\t#{h.formatted_time}\t#{h.formatted_ibu}"
  end

  def before_yeasts
    puts "\nYeasts:"
  end

  def format_yeast(y)
    puts "#{y.name}\t#{y.product_id}\t#{y.laboratory}\t#{y.form}"
  end
end

RecipeReader.new(file: ARGV[0], formatter: RecipeFormatter.new).read.output
