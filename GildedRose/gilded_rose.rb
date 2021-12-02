# frozen_string_literal: true

class GildedRose
  attr_reader :items, :updated_items

  def initialize(items)
    @items = items
    @updated_items = items.map { |item| item_factory(item).update }
  end

  def update_quality
    items.each_with_index do |item, i|
      update_item(item, updated_items[i])
    end
  end

  private

  def item_factory(item)
    ConcreteItem.new(item)
  end

  def update_item(item, updated_item)
    item.sell_in = updated_item.sell_in
    item.quality = updated_item.quality.value
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class ConcreteItem < Item
  attr_reader :species

  def initialize(item)
    super(item.name, item.sell_in, Quality.new(item.quality))
    @species = species_delegate
  end

  def update
    species.update
  end

  private

  def species_delegate
    case name
    when 'Sulfuras, Hand of Ragnaros'
      SulfurasDelegate.new(self)
    when 'Aged Brie'
      AgedBrieDelegate.new(self)
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstageDelegate.new(self)
    else
      SpeciesDelegate.new(self)
    end
  end
end

class SpeciesDelegate
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def update
    item.quality.value += calc_quality_by_normal
    item.sell_in -= 1
    item.quality.value += calc_quality_sell_in_negative
    item
  end

  private

  def calc_quality_by_normal
    -1
  end

  def calc_quality_sell_in_negative
    item.sell_in.negative? ? -1 : 0
  end
end

class SulfurasDelegate < SpeciesDelegate
  def update
    item
  end
end

class AgedBrieDelegate < SpeciesDelegate
  private

  def calc_quality_by_normal
    1
  end

  def calc_quality_sell_in_negative
    item.sell_in.negative? ? 1 : 0
  end
end

class BackstageDelegate < SpeciesDelegate
  private

  def calc_quality_by_normal
    if item.sell_in < 6
      3
    elsif item.sell_in < 11
      2
    else
      1
    end
  end

  def calc_quality_sell_in_negative
    item.sell_in.negative? ? -item.quality.value : 0
  end
end

class Quality
  attr_reader :value

  MAX_VALUE = 50
  MIN_VALUE = 0

  def initialize(value)
    @value = value
  end

  def value=(val)
    @value = max_min(val)
  end

  private

  def max_min(val)
    if val > MAX_VALUE
      MAX_VALUE
    elsif val < MIN_VALUE
      MIN_VALUE
    else
      val
    end
  end
end
