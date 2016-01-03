require 'set'
require 'prime'

class Human
  attr_reader :rational
  protected :rational

  def initialize(rational)
    @rational = rational
  end

  def to_i
    rational.to_i
  end

  def integer?
    rational == to_i
  end

  def inspect
    return to_i.to_s if integer?
    "(#{to_i}+#{remainder})"
  end

  def to_human
    self
  end

  def remainder
    return 0 if integer?
    rational - to_i
  end

  include Comparable
  def <=>(other)
    rational <=> other.to_human.rational
  end
end

class Rational
  def to_i!
    raise "#{inspect} is not integral!" if denominator != 1
    numerator
  end

  def to_human
    Human.new self
  end
end

class Integer
  def prime_factors
    prime_division.flat_map { |prime, times| Array.new times, prime }
  end

  def to_human
    Human.new self
  end
end

module Enumerable
  def lowest_common_denominator
    map(&:denominator).prime_union
  end

  def lowest_common_multiple
    denominator = lowest_common_denominator
    numerator   = map { |rational| (rational * denominator).numerator }.prime_union
    numerator.to_r / denominator
  end

  def prime_union
    each_with_object Hash.new do |integer, factors|
      integer.prime_division.each do |num, times|
        factors[num] ||= times
        factors[num] = times if factors[num] < times
      end
    end.defactor
  end

  def prime_intersection
    each_with_object(prime_union.prime_division.to_h) do |integer, all_factors|
      current_factors = integer.prime_division.to_h
      all_factors.select! { |prime, exponent| current_factors.key? prime }
      current_factors.each do |prime, exponent|
        next unless all_factors.key? prime
        next unless exponent < all_factors[prime]
        all_factors[prime] = exponent
      end
    end.defactor
  end

  def defactor
    inject(1) { |product, (num, times)| product * (num**times) }
  end

  def dissonance
    # multiplying by denominator b/c, eg 4/3 will need to repeat 3 times
    # before it falls on an integral boundary
    ints = map { |n| n.numerator * n.denominator }
    dissonance = ints.prime_union / ints.prime_intersection
    if dissonance.denominator == 1
      dissonance.numerator
    else
      dissonance
    end
  end
end

require 'set'
# array      - is assumed to be sorted ascendingly
# aggregate  - will accumulate some value as it traverses
# aggregator - receives aggregator and current value
#              returns the new aggregate and whether to prune (discontinue)
def unique_combinations(array, aggregate, all=Set.new, current=[], start=0, &aggregator)
  return all if array.length == start
  (1..array.length-start).flat_map do |offset|
    index                = start + offset
    element              = array[index-1]
    combination          = [*current, element]
    nextaggregate, prune = aggregator.call(aggregate, combination)
    next if prune
    next if all.include? combination
    all << combination
    unique_combinations(array, nextaggregate, all, combination, index, &aggregator)
  end
  all
end

require 'pp'

puts "\e[32mMy proportions\e[0m"
base   = 27
notes  = [432, 448, 480, 512, 560, 576, 640, 672, 720, 768, 784, 800].sort
root   = notes.first
result = unique_combinations(notes, :unused) { |_, chord|
  # We're not actually using the common divisor here, it's easy enough to just ask the dissonance
  [:unused, chord.dissonance>200]
}
result.reject! { |chord| chord.length < 3 }
p notes.map(&:to_human)
pp result.map { |chord| [chord.dissonance, chord.map(&:to_human)] }.sort

puts "\e[32mGalilei proportions\e[0m" # based on http://ray.tomes.biz/alex.htm
notes  = [1r, 9r/8, 5r/4, 4r/3, 3r/2, 5r/3, 15r/8].map { |n| n * 440 }
root   = notes.first
p notes.map(&:to_human)
result = unique_combinations(notes, :unused) { |_, chord|
  [:unused, chord.dissonance>200]
}
result.reject! { |chord| chord.length < 3 }
pp result.map { |chord| [chord.dissonance, chord.map(&:to_human)] }.sort
