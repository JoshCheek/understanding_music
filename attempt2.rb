require 'set'
require 'prime'

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
      "#{call} = #{@number} #{@transformations.join ' '}"
    else
      @transformations.join " "
    end
  end

  def call
    @number or raise "#{inspect} does not have a number, so cannot give a result"
    @transformations.inject @number do |lhs, (operator, rhs)|
      lhs.send operator, rhs
    end
  end
end


class Tuning
  attr_reader :base_note, :ratios, :lower_bound, :upper_bound

  def initialize(base_note, ratios, lower_bound, upper_bound)
    @base_note, @ratios, @lower_bound, @upper_bound = base_note, ratios, lower_bound, upper_bound
  end

  def ratio_denominator
    @ratio_denominator ||= ratios.lowest_common_denominator
  end

  def octaves
    @octaves ||= num_octaves.times.map { |exponent| base_note * (2**exponent) }
  end

  def notes
   @notes ||= notes_by_octave.flat_map(&:last)
  end

  def notes_by_octave
    @notes_by_octave ||= octaves.map.with_index { |octave, index| [octave, notes_for_octave(octave)] }
  end

  def notes_per_octave
    ratios.length
  end

  def inspect
    octaves = '%.2f' % (notes.length.to_f/notes_per_octave)
    "#<Tuning #{base_note}Hz-#{notes.max}Hz, #{notes.length} notes, #{octaves} octaves, #{notes_per_octave} notes / octave>"
  end

  def partial_octave?
    notes_per_octave * num_octaves != notes.length
  end

  def display(header)
    display = ""
    display << "=====  #{header}  =====\n"
    display << "  -----  Stats  -----\n"
    stats = [ ["#{notes.min} Hz",                             'Lowest note'],
              ["#{notes.max} Hz",                             'Highest note'],
              [notes.length,                                  'Notes'],
              ['%.2f' % (notes.length.to_f/notes_per_octave), 'Octaves'],
              [notes_per_octave,                              'Notes / Octave']]
    stat_length = stats.map(&:first).map(&:to_s).map(&:length).max
    stats.each { |value, description| display << sprintf("  %-#{stat_length}s %s\n", value.to_s, description) }
    display << "\n"
    display << "  -----  Octaves  -----\n"
    normalized_numerator_width = ratios.map { |r| (ratio_denominator * r).to_i!.inspect.length }.max
    note_width                 = notes.max.inspect.length
    n_width, d_width           = ratios.map { |r| [r.numerator, r.denominator] }.transpose.map { |ns| ns.map(&:inspect).map(&:length).max }
    octave_index_length        = notes_by_octave.length.pred.to_s.length

    notes_by_octave.each_with_index do |(octave, notes), octave_index|
      notes.each_with_index do |note, note_index|
        format_string = "  %#{octave_index_length+1}s "
        format_string %= (note_index.zero? ?  "#{octave_index}:" : "")
        format_string += "%-#{note_width+2}s | %#{normalized_numerator_width}d/#{ratio_denominator} | %#{n_width}d / %#{d_width}d | %p\n"
        ratio = note.to_r / octave
        display << sprintf(format_string, "#{note}Hz", (ratio_denominator*ratio).to_i!, ratio.numerator, ratio.denominator, ratio.to_math.for(octave))
      end
    end
    display
  end

  private

  def num_octaves
    @num_octaves ||= Math.log2(upper_bound.to_f/base_note).to_i.next
  end

  def notes_for_octave(octave)
    ratios.map { |ratio| ratio.to_math.for(octave).call }
          .select { |note| lower_bound <= note && note <= upper_bound }
  end
end

# ====================================================

lower_bound = 2
upper_bound = 4400

potential_notes = Set[1]
[2, 3, 5, 7].each do |multiplier|
  to_multiply = potential_notes.to_a
  while to_multiply.any?
    next_to_multiply = []
    to_multiply.each do |note|
      note *= multiplier
      next unless note <= upper_bound
      potential_notes << note
      next_to_multiply << note
    end
    to_multiply = next_to_multiply
  end
end
potential_notes.reject! { |note| note < lower_bound }

notes_to_ratios = potential_notes.map do |note1|
  [ note1,
    potential_notes.select { |note2| note1 <= note2 }
    .select { |note2| note2 < 2*note1 }
    .map    { |note2| note2.to_r / note1 }
    .sort
  ]
end

tunings = notes_to_ratios.map { |base_note, ratios| Tuning.new base_note, ratios, lower_bound, upper_bound }

# Potentials
tunings.length # => 252
tunings.map { |t| t.notes.length }.sort_by { |l| (l-88).abs }.take(10)     # => [88, 88, 89, 89, 87, 87, 87, 86, 86, 90]
tunings.map { |t| t.notes_per_octave }.sort_by { |l| (l-12).abs }.take(10) # => [12, 12, 12, 12, 12, 13, 11, 11, 13, 13]

tuning = tunings.sort_by { |t| (t.notes.length-88).abs + (t.notes_per_octave-12).abs }.first
tuning # => #<Tuning 27Hz-4096Hz, 88 notes, 7.33 octaves, 12 notes / octave>

puts tuning.display("Best piano fit")
