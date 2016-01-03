require_relative 'common'
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
