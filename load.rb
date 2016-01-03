require_relative 'lib/alternate_notes/persist'

def time
  start = Time.now
  yield
  Time.now - start
end

loaded = nil
p time: time {
  loaded = AlternateNotes::Persist.load_ratios 'ratios.dump'
}
require "pry"
binding.pry
