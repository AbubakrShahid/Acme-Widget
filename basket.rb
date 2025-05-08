class Basket
  attr_reader :product_catalog, :delivery_rules, :items

  def initialize(product_catalog, delivery_rules)
    @product_catalog = product_catalog
    @delivery_rules = delivery_rules
    @items = []
  end

  def add(product_code)
    items << product_code
  end

  def total
    subtotal = item_total + bogo_discount
    subtotal += delivery_charge(subtotal)
    subtotal
  end

  private

  def r01_items
    items.select { |code| code == 'R01' }
  end

  def non_r01_items
    items.reject { |code| code == 'R01' }
  end

  def item_total
    non_r01_items.sum { |code| product_catalog[code] }
  end

  def bogo_discount
    price = product_catalog['R01']
    count = r01_items.count
    paired = count / 2
    unpaired = count % 2
    (paired * (price + price / 2.0)) + (unpaired * price)
  end

  def delivery_charge(subtotal)
    return delivery_rules[:under_50] if subtotal < 50
    return delivery_rules[:under_90] if subtotal < 90
    delivery_rules[:greater_90]
  end
end

def total_for(codes)
  product_catalog = {
    'R01' => 32.95,  # First unit full price
    'G01' => 24.95,  # Regular price
    'B01' => 7.95    # Regular price
  }

  delivery_rules = {
    under_50: 4.95,   # Delivery charge for total < 50
    under_90: 2.95,   # Delivery charge for total < 90
    greater_90: 0     # Free delivery for totals >= 90
  }

  basket = Basket.new(product_catalog, delivery_rules)
  codes.each { |code| basket.add(code) }
  basket.total
end

def truncate_to_two_decimal_places(amount)
  (amount * 100).floor / 100.0
end

[ 
  ['B01', 'G01'],
  ['R01', 'R01'],
  ['R01', 'G01'],
  ['B01', 'B01', 'R01', 'R01', 'R01'],
].each do |code_groups|
  puts "For the following codes #{code_groups}"
  puts "Total Amount = #{truncate_to_two_decimal_places(total_for(code_groups))}"  
end
