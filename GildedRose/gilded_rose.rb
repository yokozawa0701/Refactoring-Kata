# frozen_string_literal: true

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_item(item)
    end
  end

  private

  def calc_quality_by_normal(item)
    result = 0
    if item.name == 'Aged Brie' || item.name == 'Backstage passes to a TAFKAL80ETC concert'
      return result if item.quality >= 50

      result += 1
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        result += 1 if item.sell_in < 11
        result += 1 if item.sell_in < 6
      end
    else
      result -= 1 if item.quality.positive?
    end
    result
  end

  def update_item(item)
    return if item.name == 'Sulfuras, Hand of Ragnaros'

    item.quality += calc_quality_by_normal(item)
    item.sell_in = item.sell_in - 1
    return unless item.sell_in.negative?

    if item.name != 'Aged Brie'
      if item.name != 'Backstage passes to a TAFKAL80ETC concert'
        item.quality = item.quality - 1 if item.quality.positive?
      else
        item.quality -= item.quality
      end
    else
      item.quality = item.quality + 1 if item.quality < 50
    end
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
