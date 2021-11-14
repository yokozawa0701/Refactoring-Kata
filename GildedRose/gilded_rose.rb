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
    case item.name
    when 'Sulfuras, Hand of Ragnaros'
      Sulfuras.new(item)
    when 'Aged Brie'
      AgedBrie.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      Backstage.new(item)
    else
      ConcreteItem.new(item)
    end
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
  def initialize(item)
    super(item.name, item.sell_in, Quality.new(item.quality))
  end

  def update
    quality.value += calc_quality_by_normal
    @sell_in -= 1
    quality.value += calc_quality_sell_in_negative
    self
  end

  private

  def quality_less_than_50?
    quality.value < 50
  end

  def calc_quality_by_normal
    quality.value.positive? ? -1 : 0
  end

  def calc_quality_sell_in_negative
    return 0 unless sell_in.negative?

    quality.value.positive? ? -1 : 0
  end
end

# スーパークラスのメソッドを使わないサブクラスはあってはいけない
class Sulfuras < ConcreteItem
  def update
    self
  end
end

class AgedBrie < ConcreteItem
  def calc_quality_by_normal
    quality_less_than_50? ? 1 : 0
  end

  def calc_quality_sell_in_negative
    return 0 unless sell_in.negative?

    quality_less_than_50? ? 1 : 0
  end
end

class Backstage < ConcreteItem
  def calc_quality_by_normal
    result = 0
    result += 1 if quality_less_than_50?
    result += 1 if sell_in < 11
    result += 1 if sell_in < 6
    result
  end

  def calc_quality_sell_in_negative
    return 0 unless sell_in.negative?

    -quality.value
  end
end

class Quality
  attr_accessor :value

  MAX_NUMBER = 50
  MIN_NUMBER = 0

  def initialize(value)
    @value = value
  end

  def +(other)
    [MAX_NUMBER, value + other].min
  end

  def -(other)
    [MIN_NUMBER, value - other].max
  end
end
