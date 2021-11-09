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
    return result if item.name == 'Sulfuras, Hand of Ragnaros'

    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      result -= 1 if item.quality.positive?
    else
      return result if item.quality >= 50

      result += 1
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        result += 1 if item.sell_in < 11
        result += 1 if item.sell_in < 6
      end
    end
    result
  end

  def update_item(item)
    item.quality += calc_quality_by_normal(item)
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in = item.sell_in - 1
    end
    if item.sell_in.negative?
      if item.name != 'Aged Brie'
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality.positive?
            if item.name != 'Sulfuras, Hand of Ragnaros'
              item.quality = item.quality - 1
            end
          end
        else
          item.quality -= item.quality
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
        end
      end
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
