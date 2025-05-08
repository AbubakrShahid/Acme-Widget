require_relative '../basket'

RSpec.describe 'Basket total with BOGO on R01' do
  # Sample Cases
  
  it 'calculates total for B01, G01' do
    # Breakdown: 
    # B01 (Blue Widget) = 7.95
    # G01 (Green Widget) = 24.95
    # Total: 7.95 + 24.95 = 32.90 → delivery fee: 4.95 → final total = 37.85
    expect(truncate_to_two_decimal_places(total_for(%w[B01 G01]))).to eq(37.85)
  end
  
  it 'calculates total for R01, R01' do
    # Breakdown:
    # R01 (Red Widget) x2: First at full price (32.95) and second at half price (16.475)
    # Total: 32.95 + 16.475 = 49.425 → delivery fee: 4.95 → final total = 54.37
    expect(truncate_to_two_decimal_places(total_for(%w[R01 R01]))).to eq(54.37)
  end
  
  it 'calculates total for R01, G01' do
    # Breakdown:
    # R01 (Red Widget) at full price = 32.95
    # G01 (Green Widget) at regular price = 24.95
    # Total: 32.95 + 24.95 = 57.90 → delivery fee: 2.95 → final total = 60.85
    expect(truncate_to_two_decimal_places(total_for(%w[R01 G01]))).to eq(60.85)
  end
  
  it 'calculates total for B01, B01, R01, R01, R01' do
    # Breakdown:
    # B01 (Blue Widget) x2 = 7.95 + 7.95 = 15.90
    # R01 (Red Widget) x3: First pair BOGO = 32.95 + 16.475, third at full price = 32.95
    # Total: 15.90 + 32.95 + 16.475 + 32.95 = 98.27 → free delivery
    expect(truncate_to_two_decimal_places(total_for(%w[B01 B01 R01 R01 R01]))).to eq(98.27)
  end
  

  # Additional Test Cases
  # Test for 3 R01 (1.5x R01 price for one pair, full price for 1)
  # R01 + R01 = BOGO (32.95 + 16.475), R01 = 32.95 → subtotal: 82.375 → delivery: 2.95 → total: 85.325
  it 'calculates total for R01, R01, R01' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01 R01 R01]))).to eq(85.32)
  end

  # Test for 4 R01 (2 BOGO pairs)
  # (32.95 + 16.475) * 2 = 98.85 → delivery = free
  it 'calculates total for R01, R01, R01, R01' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01 R01 R01 R01]))).to eq(98.85)
  end

  # Test for G01, R01, R01 (1 R01 BOGO, 1 G01)
  # R01 + R01 = BOGO (32.95 + 16.475), G01 = 24.95 → subtotal = 74.375 → delivery: 2.95 → total: 77.325
  it 'calculates total for G01, R01, R01' do
    expect(truncate_to_two_decimal_places(total_for(%w[G01 R01 R01]))).to eq(77.32)
  end

  # Test for B01, R01, R01, R01 (1 R01 pair BOGO, 1 R01 full, 1 B01)
  # R01 + R01 = BOGO (32.95 + 16.475), R01 = 32.95, B01 = 7.95 → subtotal: 90.325 → delivery: free
  it 'calculates total for B01, R01, R01, R01' do
    expect(truncate_to_two_decimal_places(total_for(%w[B01 R01 R01 R01]))).to eq(90.32)
  end

  # Test for G01, G01, B01 (no BOGO)
  # G01 x2 = 49.90, B01 = 7.95 → subtotal = 57.85 → delivery: 2.95 → total = 60.80
  it 'calculates total for G01, G01, B01' do
    expect(truncate_to_two_decimal_places(total_for(%w[G01 G01 B01]))).to eq(60.8)
  end

  # Test for R01 only
  # R01 = 32.95 → delivery: 4.95 → total: 37.90
  it 'calculates total for R01 only' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01]))).to eq(37.90)
  end

  # Test for 5 R01 (2 BOGO pairs + 1 R01 full)
  # (32.95 + 16.475) * 2 = 98.85, + 32.95 → subtotal = 131.8 → delivery: free
  it 'calculates total for 5 red shirts (R01 x5)' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01 R01 R01 R01 R01]))).to eq(131.8)
  end

  # Test for R01, B01, R01 (non-adjacent BOGO)
  # R01 + R01 = BOGO (32.95 + 16.475), B01 = 7.95 → subtotal = 57.375 → delivery: 2.95 → total: 60.325
  it 'calculates total for R01, B01, R01' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01 B01 R01]))).to eq(60.32)
  end

  # Test for R01, B01, G01 (no BOGO)
  # R01 = 32.95, B01 = 7.95, G01 = 24.95 → subtotal = 65.85 → delivery: free
  it 'calculates total for R01, B01, G01 (no BOGO)' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01 B01 G01]))).to eq(68.80)
  end

  # Test for R01, R01, B01, G01 (1 R01 pair BOGO)
  # R01 + R01 = BOGO (32.95 + 16.475), B01 = 7.95, G01 = 24.95 → subtotal = 82.325 → delivery: free
  it 'calculates total for R01, R01, B01, G01' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01 R01 B01 G01]))).to eq(85.27)
  end

  # Test for only G01 and B01
  # G01 = 24.95, B01 = 7.95 → subtotal = 32.90 → delivery: 4.95 → total: 37.85
  it 'calculates total for only G01 and B01' do
    expect(truncate_to_two_decimal_places(total_for(%w[G01 B01]))).to eq(37.85)
  end

  # Test for 6 R01 (3 BOGO pairs)
  # (32.95 + 16.475) * 3 = 147.825 → delivery: free
  it 'calculates total for R01 x6' do
    expect(truncate_to_two_decimal_places(total_for(%w[R01 R01 R01 R01 R01 R01]))).to eq(148.27)
  end
end
