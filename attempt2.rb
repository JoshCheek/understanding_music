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

# Potentials
tunings.length # => 252
tunings.map { |t| t.notes.length }.sort_by { |l| (l-88).abs }.take(10)     # => [88, 88, 89, 89, 87, 87, 87, 86, 86, 90]
tunings.map { |t| t.notes_per_octave }.sort_by { |l| (l-12).abs }.take(10) # => [12, 12, 12, 12, 12, 13, 11, 11, 13, 13]

tuning = tunings.sort_by { |t| (t.notes.length-88).abs + (t.notes_per_octave-12).abs }.first
tuning # => #<Tuning 27Hz-4096Hz, 88 notes, 7.33 octaves, 12 notes / octave>

puts tuning.display("Best piano fit")
