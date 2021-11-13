# frozen_string_literal: true

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.map do |item|
      item_factory(item).update
    end
  end

  private

  def item_factory(item)
    case item.name
    when 'Sulfuras, Hand of Ragnaros'
      Sulfuras.new(name: item.name, sell_in: item.sell_in, quality: item.quality)
    else
      ConcreteItem.new(name: item.name, sell_in: item.sell_in, quality: item.quality)
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

class ConcreteItem < Item

  def initialize(name:, sell_in:, quality:)
    super(name, sell_in, quality)
  end

  def update
    return self if sulfuras?

    self.quality += calc_quality_by_normal
    self.sell_in -= 1
    self.quality += calc_quality_sell_in_negative
    self
  end
  
  private

  def aged_brie?
    name == 'Aged Brie'
  end

  def backstage?
    name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def sulfuras?
    name == 'Sulfuras, Hand of Ragnaros'
  end

  def quality_less_than_50?
    quality < 50
  end

  def calc_quality_by_normal
    result = 0
    if aged_brie?
      result += 1 if quality_less_than_50?
    elsif backstage?
      result += 1 if quality_less_than_50?
      result += 1 if sell_in < 11
      result += 1 if sell_in < 6
    elsif quality.positive?
      result -= 1
    end
    result
  end

  def calc_quality_sell_in_negative
    result = 0
    return 0 unless sell_in.negative?

    if aged_brie?
      result += 1 if quality_less_than_50?
    elsif backstage?
      result += -quality
    elsif quality.positive?
      result -= 1
    end
    result
  end
end

class Sulfuras < ConcreteItem
end
