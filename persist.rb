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

# Test it
if $PROGRAM_NAME == __FILE__
  chord_ratios = {
    100 => {125=>[ 5,  4], 120=>[ 6,  5], 130=>[13, 10]},
    120 => {100=>[ 5,  6], 130=>[13, 12], 125=>[25, 24]},
    125 => {100=>[ 4,  5], 120=>[24, 25], 130=>[26, 25]},
    130 => {100=>[10, 13], 120=>[12, 13], 125=>[25, 26]},
  }

  require 'tmpdir'
  loaded = Dir.mktmpdir do |tmpdir|
    filename = File.join tmpdir, 'dump'
    Persist.dump_ratios chord_ratios, filename
    Persist.load_ratios filename
  end

  require 'pp'
  def red(text)
    "\e[31m#{text}\e[0m"
  end

  if loaded != chord_ratios
    puts red("EXPECTED"), chord_ratios.pretty_inspect,
         '',
         red("ACTUAL"), loaded.pretty_inspect
  else
    puts "\e[32mLOOKS GOOD!!\e[0m"
  end
end
