# frozen_string_literal: true

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      concrete_item = item_factory(item)
      update_item(concrete_item)
    end
  end

  private

  def item_factory(item)
    item
  end

  def aged_brie?(item)
    item.name == 'Aged Brie'
  end

  def backstage?(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def sulfuras?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def quality_less_than_50?(item)
    item.quality < 50
  end

  def calc_quality_by_normal(item)
    result = 0
    if aged_brie?(item)
      result += 1 if quality_less_than_50?(item)
    elsif backstage?(item)
      result += 1 if quality_less_than_50?(item)
      result += 1 if item.sell_in < 11
      result += 1 if item.sell_in < 6
    elsif item.quality.positive?
      result -= 1
    end
    result
  end

  def update_item(item)
    return if sulfuras?(item)

    item.quality += calc_quality_by_normal(item)
    item.sell_in -= 1
    item.quality += calc_quality_sell_in_negative(item)
  end

  def calc_quality_sell_in_negative(item)
    result = 0
    return 0 unless item.sell_in.negative?

    if aged_brie?(item)
      result += 1 if quality_less_than_50?(item)
    elsif backstage?(item)
      result += -item.quality
    elsif item.quality.positive?
      result -= 1
    end
    result
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
