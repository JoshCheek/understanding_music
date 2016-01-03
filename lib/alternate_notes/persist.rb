# The reality is that this is useless b/c it takes
# ~25s to calculate the results
# ~23s to dump them to a file
# ~39s to load them from the file
module AlternateNotes
  module Persist
    extend self

    def dump_ratios(chord_ratios, filename)
      notes = chord_ratios.keys
      File.open filename, "w" do |file|
        file.puts notes.join(' ')
        chord_ratios.each do |note1, note_ratios|
          note_ratios.each { |note2, (r1, r2)| file.puts "#{note2} #{r1} #{r2}" }
        end
      end
    end

    def load_ratios(filename)
      File.open filename, 'r' do |file|
        notes = file.gets.split.map(&:to_i)
        num_note_ratios = notes.length-1 # b/c it doesn't include the ratio to itself
        notes.each_with_object Hash.new do |note1, chord_ratios|
          chord_ratios[note1] = note_ratios = {}
          num_note_ratios.times do
            note2, r1, r2 = file.gets.split.map(&:to_i)
            note_ratios[note2] = [r1.to_i, r2.to_i]
          end
        end
      end
    end
  end
end
