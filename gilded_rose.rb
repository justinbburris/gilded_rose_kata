def update_quality(items)
  items.each do |item|
    modify_quality(item)
  end
end

def update_quality2(items)
  items.each do |item|
    modifier = QualityModifer.fetch_modifer(item)
    modifer.adjust_quality!
  end
end

class QualityModifer
  def self.fetch_modifer(item)
    case(item.name)
    when 'Sulfuras, Hand of Ragnaros'
      SulfurasModifer.new(item)
    when 'Conjured Mana Cake'
      ConjuredModifer.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      PassModifer.new(item)
    when 'Aged Brie'
      BrieModifer.new(item)
    else
      NormalModifer.new(item)
    end
  end
end

def modify_quality(item)
  case(item.name)
  when 'Sulfuras, Hand of Ragnaros'
    return
  when 'Conjured Mana Cake'
    modify_conjured(item)
  when 'Backstage passes to a TAFKAL80ETC concert'
    modify_pass(item)
  when 'Aged Brie'
    modify_brie(item)
  else
    modify_normal(item)
  end
end

class NormalModifer
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def adjust_quality!
    if item.quality > 0
      item.quality -= 1
    end

    item.sell_in -= 1

    if item.sell_in < 0
      if item.quality > 0
        item.quality -= 1
      end
    end
  end
end

def modify_normal(item)
  if item.quality > 0
    item.quality -= 1
  end

  item.sell_in -= 1

  return if item.sell_in > 0

  if item.quality > 0
    item.quality -= 1
  end
end

def modify_brie(item)
  if item.quality < 50
    item.quality += 1
  end

  item.sell_in -= 1

  if item.sell_in < 0
    if item.quality < 50
      item.quality += 1
    end
  end
end

def modify_conjured(item)
  if item.quality > 0
    if item.sell_in > 0
      item.quality -= 2
    else
      item.quality -= 4
    end
  end

  item.sell_in -= 1
end

def modify_pass(item)
  if item.sell_in < 11
    if item.quality < 50
      item.quality += 1
    end
  end
  if item.sell_in < 6
    if item.quality < 50
      item.quality += 1
    end
  end

  if item.quality < 50
    item.quality += 1
  end

  item.sell_in -= 1

  if item.sell_in < 0
    item.quality = item.quality - item.quality
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

