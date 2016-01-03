require 'set'
require 'prime'

class LazyMath
  def initialize(transformations:[], number: nil)
    @number          = number
    @transformations = transformations
  end

  def *(number)
    LazyMath.new transformations: @transformations + [[:*, number]]
  end

  def /(number)
    LazyMath.new transformations: @transformations + [[:/, number]]
  end

  def for(number)
    LazyMath.new number: number, transformations: @transformations
  end

  def inspect
    if @number
      "#{result} = #{@number} #{@transformations.join ' '}"
    else
      @transformations.join " "
    end
  end

  def result
    @number or raise "#{inspect} does not have a number, so cannot give a result"
    @transformations.inject @number do |lhs, (operator, rhs)|
      lhs.send operator, rhs
    end
  end
end

class Rational
  def to_i!
    raise "#{inspect} is not integral!" if denominator != 1
    numerator
  end
  def to_math
    math = LazyMath.new
    numerator.prime_factors.each   { |factor| math *= factor }
    denominator.prime_factors.each { |factor| math /= factor }
    math
  end
end

class Integer
  def prime_factors
    prime_division.flat_map { |prime, times| Array.new times, prime }
  end
end

module Enumerable
  def lowest_common_denominator
    each_with_object Hash.new do |rational, factors|
      rational.denominator.prime_division.each do |num, times|
        factors[num] ||= times
        factors[num] = times if factors[num] < times
      end
    end.defactor
  end

  def defactor
    inject(1) { |product, (num, times)| product * (num**times) }
  end
end

lower_bound = 32
upper_bound = 4400

notes = Set[1]
[2, 3, 5].each do |multiplier|
  to_multiply = notes.to_a
  while to_multiply.any?
    next_to_multiply = []
    to_multiply.each do |note|
      note *= multiplier
      next unless note <= upper_bound
      notes << note
      next_to_multiply << note
    end
    to_multiply = next_to_multiply
  end
end
notes.reject! { |note| note < lower_bound }

notes.length # => 121
notes_to_ratios = notes
                    .map do |note1|
                      [ note1,
                        notes.select { |note2| note1 < note2 }
                             .select { |note2| note2 < 2*note1 }
                             .map    { |note2| note2.to_r / note1 }
                             .reject { |ratio| ratio == 1 }
                             .sort
                      ]
                    end
                    .reject do |note, ratios|
                      ratios.length < 12
                    end
                    .sort_by do |note1, ratios|
                      ratios.inject(1) { |multiplier, ratio| multiplier * ratio.numerator }
                    end

base_note, ratios = notes_to_ratios.first
base_note # => 120
ratios    # => [(25/24), (16/15), (9/8), (6/5), (5/4), (4/3), (27/20), (3/2), (8/5), (5/3), (9/5), (15/8)]
  .length # => 12

ratios.lowest_common_denominator # => 120
      .prime_factors             # => [2, 2, 2, 3, 5]

ratios.map { |ratio| [ratio, ratio.to_math.for(base_note)] }
# => [[(25/24), 125 = 120 * 5 * 5 / 2 / 2 / 2 / 3],
#     [(16/15), 128 = 120 * 2 * 2 * 2 * 2 / 3 / 5],
#     [(9/8), 135 = 120 * 3 * 3 / 2 / 2 / 2],
#     [(6/5), 144 = 120 * 2 * 3 / 5],
#     [(5/4), 150 = 120 * 5 / 2 / 2],
#     [(4/3), 160 = 120 * 2 * 2 / 3],
#     [(27/20), 162 = 120 * 3 * 3 * 3 / 2 / 2 / 5],
#     [(3/2), 180 = 120 * 3 / 2],
#     [(8/5), 192 = 120 * 2 * 2 * 2 / 5],
#     [(5/3), 200 = 120 * 5 / 3],
#     [(9/5), 216 = 120 * 3 * 3 / 5],
#     [(15/8), 225 = 120 * 3 * 5 / 2 / 2 / 2]]

octave = base_note * 2
ratios.map { |ratio| [ratio, ratio.to_math.for(octave)] }
# => [[(25/24), 250 = 240 * 5 * 5 / 2 / 2 / 2 / 3],
#     [(16/15), 256 = 240 * 2 * 2 * 2 * 2 / 3 / 5],
#     [(9/8), 270 = 240 * 3 * 3 / 2 / 2 / 2],
#     [(6/5), 288 = 240 * 2 * 3 / 5],
#     [(5/4), 300 = 240 * 5 / 2 / 2],
#     [(4/3), 320 = 240 * 2 * 2 / 3],
#     [(27/20), 324 = 240 * 3 * 3 * 3 / 2 / 2 / 5],
#     [(3/2), 360 = 240 * 3 / 2],
#     [(8/5), 384 = 240 * 2 * 2 * 2 / 5],
#     [(5/3), 400 = 240 * 5 / 3],
#     [(9/5), 432 = 240 * 3 * 3 / 5],
#     [(15/8), 450 = 240 * 3 * 5 / 2 / 2 / 2]]
