require_relative 'common'

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
tunings.length # => 252
tunings.reject! { |t| t.notes.length < 50 } # Remove tunings that are way too tiny
tunings.length # => 197

# Characteristics that might be interesting:
  # How many notes they have, in particular, whether they have 88 a piano, so you don't have to buy new hardware :P
  tunings.map { |t| t.notes.length }.sort_by { |l| (l-88).abs }.take(10)     # => [88, 88, 89, 89, 87, 87, 87, 90, 86, 90]

  # How many notes are in an octave, in particular if they have 12 like a piano, b/c that would translate nicely
  tunings.map { |t| t.notes_per_octave }.sort_by { |l| (l-12).abs }.take(10) # => [12, 12, 12, 12, 13, 11, 13, 13, 10, 14]

  # Lowest octave dissonance (if you played all notes in an octave at once, at what wavelength do they harmonize?)
  tunings.map { |t| t.octave_dissonance }.sort.take(10) # => [2520, 5040, 5040, 5040, 75600, 75600, 75600, 151200, 151200, 151200]

  # Largest octave
  tunings.map { |t| t.notes_per_octave }.sort.take(10) # => [6, 6, 6, 7, 9, 9, 9, 10, 10, 10]

  # Smallest octave
  tunings.map { |t| t.notes_per_octave }.sort.reverse.take(10) # => [59, 58, 58, 58, 58, 58, 58, 58, 58, 58]

  # How many have 6-14 notes per octave (ie you could probably play an octave with one hand)
  tunings.map { |t| t.notes_per_octave }.select { |n| 6 <= n && n <= 14 }.length # => 19

  # Average number of notes per octave
  tunings.map { |t| t.notes_per_octave }.inject(0.0, :+) / tunings.length # => 36.34517766497462

  # Average number of octaves
  tunings.map { |t| t.octaves.length }.inject(0.0, :+) / tunings.length # => 4.035532994923858

  # Largest number of chords with 60 dissonance (commenting out b/c it's expensive to calculate)
  # tunings.map { |t| t.resonant_chords.count { |c| c.dissonance == 60 } }.sort.reverse.take(30) # => [44, 44, 42, 42, 42, 42, 42, 42, 41, 41, 41, 41, 41, 40, 40, 40, 39, 39, 39, 39, 39, 39, 38, 37, 37, 37, 37, 37, 37, 37]

require 'rouge'
tunings
  .sort_by { |t| (t.notes.length-88).abs + (t.notes_per_octave-12).abs }
  .take(10)
  .each_with_index { |tuning, index|
    inspected = tuning.display("#{index}/#{tunings.length} #{tuning.inspect}")
                      .delete("#")
    if $stdout.tty?
      puts Rouge::Formatters::Terminal256
             .new(theme: Rouge::Themes::Monokai.name)
             .format(Rouge::Lexers::Ruby.new.lex inspected)
      puts "Press return to see the next one"
      gets
    else
      puts inspected
    end
  }
