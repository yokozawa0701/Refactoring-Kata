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
    elsif item.quality.positive?
      result -= 1
    end
    result
  end

  def update_item(item)
    return if item.name == 'Sulfuras, Hand of Ragnaros'

    item.quality += calc_quality_by_normal(item)
    item.sell_in -= 1
    item.quality += calc_quality_sell_in_negative(item)
  end

  def calc_quality_sell_in_negative(item)
    return 0 unless item.sell_in.negative?
    return 1 if item.name == 'Aged Brie' && item.quality < 50
    return -item.quality if item.name == 'Backstage passes to a TAFKAL80ETC concert'
    return -1 if item.quality.positive?
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
