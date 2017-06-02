require 'pp'
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

  def to_s
    if @number
      "#{call} = #{@number} #{@transformations.join ' '}"
    else
      @transformations.join " "
    end
  end
  alias inspect to_s

  def call
    @number or raise "#{inspect} does not have a number, so cannot give a result"
    @transformations.inject @number do |lhs, (operator, rhs)|
      lhs.send operator, rhs
    end
  end
end


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

  def to_s
    return to_i.to_s if integer?
    "(#{to_i}+#{remainder})"
  end
  alias inspect to_s

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

  def to_human
    Human.new self
  end

  def to_math
    to_r.to_math
  end

  def to_i!
    self
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

  def octave_dissonance
    notes_by_octave.first.last.dissonance
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


    chord_lines = [
      "  -----  Chords  -----",
      *resonant_chords.pretty_inspect.lines.map { |line| "  #{line.chomp}" },
    ]

    octave_lines = [
      "  -----  Example Octave  -----",
      *notes_by_octave.take(1).flat_map do |octave, notes|
        normalized_numerator_width = ratios.map { |r| (ratio_denominator * r).to_i!.inspect.length }.max
        note_width                 = notes.max.inspect.length
        n_width, d_width           = ratios.map { |r| [r.numerator, r.denominator] }.transpose.map { |ns| ns.map(&:inspect).map(&:length).max }
        octave_index_length        = notes_by_octave.length.pred.to_s.length
        notes.map.with_index do |note, note_index|
          format_string = "  %-#{note_width+2}s | %#{normalized_numerator_width}d/#{ratio_denominator} | %#{n_width}d / %#{d_width}d | %p"
          ratio = note.to_r / octave
          sprintf(format_string,
                  "#{note} Hz",
                  (ratio_denominator*ratio).to_i,
                  ratio.numerator,
                  ratio.denominator,
                  ratio.to_math.for(octave))
        end
      end
    ]
    chord_lines  << "" while chord_lines.length < octave_lines.length
    octave_lines << "" while chord_lines.length > octave_lines.length

    chord_line_length = chord_lines.map(&:length).max
    chord_lines.zip(octave_lines).map do |chord_line, octave_line|
      display << sprintf("%-#{chord_line_length}s  %-s\n", chord_line, octave_line)
    end

    display << "\n"
    display << "    -----  Notes By Octave  -----\n"
    table = [['Octave', ratios], [:divider]] + notes_by_octave.map.with_index do |(octave, notes), octave_index|
      [octave_index, notes]
    end

    note_length = [*notes, *ratios].map(&:inspect).map(&:length).max
    key_length  = table.map { |row| row == [:divider] ? 1 : row.first.inspect.length }.max
    table.each do |keycol, cells|
      format = "    %-#{key_length}s | %#{note_length}s\n"
      if keycol == :divider
        display << sprintf(
          format,
          '-'*key_length,
          '-'*(note_length*notes_per_octave + notes_per_octave)
        )
      else
        display << sprintf(format, keycol, cells.map { |c| c.inspect.ljust note_length }.join(' '))
      end
    end

    display
  end

  def resonant_chords
    @resonant_chords ||= begin
      notes = notes_for_octave base_note
      unique_combinations(notes) { |chord| 200 < chord.dissonance }
                         .reject { |chord| chord.length < 3 }
                         .map    { |chord| Chord.new chord }
                         .sort
    end
  end

  private

  def num_octaves
    @num_octaves ||= Math.log2(upper_bound.to_f/base_note).to_i.next
  end

  def notes_for_octave(octave)
    ratios.map { |ratio| ratio.to_math.for(octave).call }
          .select { |note| lower_bound <= note && note <= upper_bound }
  end

  def unique_combinations(array, all=Set.new, current=[], start=0, &prune_search)
    return all if array.length == start
    (1..array.length-start).flat_map do |offset|
      index       = start + offset
      element     = array[index-1]
      combination = [*current, element]
      next if prune_search.call combination
      next if all.include? combination
      all << combination
      unique_combinations(array, all, combination, index, &prune_search)
    end
    all
  end

end

class Chord
  attr_reader :notes, :base, :ratios

  def initialize(notes)
    @base     = notes.min
    rationals = notes.map { |note| note.to_r / base }
    denom     = rationals.lowest_common_denominator
    @ratios, @notes = rationals.map { |rational| (rational*denom).to_i! }
                               .zip(notes)
                               .sort_by { |ratio, note| ratio }
                               .transpose
  end

  def dissonance
    @dissonance ||= @notes.dissonance
  end

  def inspect
    @inspection ||= "#<Chord dissonance: #{dissonance.to_s.rjust 3}, notes: [#{@notes.map(&:to_human).join(', ')}], ratios: #{ratios.join ':'}>"
  end

  include Comparable
  def <=>(chord)
    dissonance <=> chord.dissonance
  end
end

