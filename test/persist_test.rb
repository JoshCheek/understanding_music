require 'tmpdir'
require 'alternate_notes/persist'

class PersistTest < Minitest::Test
  def test_it_persists_and_loads
    chord_ratios = {
      100 => {125=>[ 5,  4], 120=>[ 6,  5], 130=>[13, 10]},
      120 => {100=>[ 5,  6], 130=>[13, 12], 125=>[25, 24]},
      125 => {100=>[ 4,  5], 120=>[24, 25], 130=>[26, 25]},
      130 => {100=>[10, 13], 120=>[12, 13], 125=>[25, 26]},
    }

    filename = nil
    loaded = Dir.mktmpdir do |tmpdir|
      filename = File.join tmpdir, 'dump'
      refute File.exist? filename
      AlternateNotes::Persist.dump_ratios chord_ratios, filename
      assert File.exist? filename
      AlternateNotes::Persist.load_ratios filename
    end
    refute File.exist? filename

    assert_equal chord_ratios, loaded
  end
end
