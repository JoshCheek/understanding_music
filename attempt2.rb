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

# Characteristics that might be interesting:
  # How many notes they have, in particular, whether they have 88 a piano, so you don't have to buy new hardware :P
  tunings.map { |t| t.notes.length }.sort_by { |l| (l-88).abs }.take(10)     # => [88, 88, 89, 89, 87, 87, 87, 86, 86, 90]

  # How many notes are in an octave, in particular if they have 12 like a piano, b/c that would translate nicely
  tunings.map { |t| t.notes_per_octave }.sort_by { |l| (l-12).abs }.take(10) # => [12, 12, 12, 12, 12, 13, 11, 11, 13, 13]

  # Lowest total dissonance (if you played all notes at once, at what wavelength do they harmonize?)
  tunings.map { |t| t.octave_dissonance }.sort.take(10) # => NoMethodError: undefined method `dissonance' for #<Tuning 2Hz-4096Hz, 23 notes, 11.50 octaves, 2 notes / octave>

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
      puts "Press a key"
    else
      puts inspected
    end
    gets
  }

# ~> NoMethodError
# ~> undefined method `dissonance' for #<Tuning 2Hz-4096Hz, 23 notes, 11.50 octaves, 2 notes / octave>
# ~>
# ~> /Users/josh/alternate_notes/attempt2.rb:42:in `block in <main>'
# ~> /Users/josh/alternate_notes/attempt2.rb:42:in `map'
# ~> /Users/josh/alternate_notes/attempt2.rb:42:in `<main>'
