lowest_note = 55
highest_a   = lowest_note *  # => 55
                        2 *  # => 110
                        2 *  # => 220
                        2 *  # => 440
                        2 *  # => 880
                        2 *  # => 1760
                        2    # => 3520

highest_note  = highest_a * 5 / 4         # => 4400

def prime_factors(n, factors=[], divisor=2)
  return factors                             if n == 1
  return prime_factors n, factors, divisor+1 if n % divisor != 0
  prime_factors n/divisor, [*factors, divisor], divisor
end

# prime factors available at various interesting notes
prime_factors lowest_note  # => [5, 11]
prime_factors highest_a    # => [2, 2, 2, 2, 2, 2, 5, 11]
prime_factors highest_note # => [2, 2, 2, 2, 5, 5, 11]

# Factors that allow us to make every note below the highest note
factors = 2.upto(highest_note).each_with_object(Hash.new) do |frequency, all|
  prime_factors(frequency).group_by(&:itself).each do |n, ns|
    all[n] = [all.fetch(n, 0), ns.length].max
  end
end

factors        # => {2=>12, 3=>7, 5=>5, 7=>4, 11=>3, 13=>3, 17=>2, 19=>2, 23=>2, 29=>2, 31=>2, 37=>2, 41=>2, 43=>2, 47=>2, 53=>2, 59=>2, 61=>2, 67=>1, 71=>1, 73=>1, 79=>1, 83=>1, 89=>1, 97=>1, 101=>1, 103=>1, 107=>1, 109=>1, 113=>1, 127=>1, 131=>1, 137=>1, 139=>1, 149=>1, 151=>1, 157=>1, 163=>1, 167=>1, 173=>1, 179=>1, 181=>1, 191=>1, 193=>1, 197=>1, 199=>1, 211=>1, 223=>1, 227=>1, 229=>1, 233=>1, 239=>1, 241=>1, 251=>1, 257=>1, 263=>1, 269=>1, 271=>1, 277=>1, 281=>1, 283=>1, 293=>1, 307=>1, 311=>1, 313=>1, 317=>1, 331=>1, 337=>1, 347=>1, 349=>1, 353=>1, 359=>1, 367=>1, 373=>1, 379=>1, 383=>1, 389=>1, 397=>1, 401=>1, 409=>1, 419=>1, 421=>1, 431=>1, 433=>1, 439=>1, 443=>1, 449=>1, 457=>1, 461=>1, 463=>1, 467=>1, 479=>1, 487=>1, 491=>1, 499=>1, 503=>1, 509=>1, 521=>1, 523=>1, 541=>1, 547=>1, 557=>1, 563=>1, 569=>1, 571=>1, 577=>1, 587=>1, 593=>1, 599=>1, 601=>1, 607=>1, 613=>1, 617=>1, 619=>1, 631=>1, 641=>1, 643=>1, 647=>1, 653=>1, 659=>1, 661=>1, 673=>1, 677=>1, 683=>1, 691=>1, 701=>1, 709=>1, 719=>1, 727=>1, 733=>1, 739=>1, 743=>1, 751=>1, 757=>1, 761=>1, 769=>1, 773=>1, 787=>1, 797=>1, 809=>1, 811=>1, 821=>1, 823=>1, 827=>1, 829=>1, 839=>1, 853=>1, 857=>1, 859=>1, 863=>1, 877=>1, 881=>1, 883=>1, 887=>1, 907=>1, 911=>1, 919=>1, 929=>1, 937=>1, 941=>1, 947=>1, 953=>1, 967=>1, 971=>1, 977=>1, 983=>1, 991=>1, 997=>1, 1009=>1, 1013=>1, 1019=>1, 1021=>1, 1031=>1, 1033=>1, 1039=>1, 1049=>1, 1051=>1, 1061=>1, 1063=>1, 1069=>1, 1087=>1, 1091=>1, 1093=>1, 1097=>1, 1103=>1, 1109=>1, 1117=>1, 1123=>1, 1129=>1, 1151=>1, 1153=>1, 1163=>1, 1171=>1, 1181=>1, 1187=>1, 1193=>1, 1201=>1, 1213=>1, 1217=>1, 1223=>1, 1229=>1, 1231=>1, 1237=>1, 1249=>1, 1259=>1, 1277=>1, 1279=>1, 1283=>1, 1289=>1, 1291=>1, 1297=>1, 1301=>1, 1303=>1, 1307=>1, 1319=>1, 1321=>1, 1327=>1, 1361=>1, 1367=>1, 1373=>1, 1381=>1, 1399=>1, 1409=>1, 1423=>1, 1427=>1, 1429=>1, 1433=>1, 1439=>1, 1447=>1, 1451=>1, 1453=>1, 1459=>1, 1471=>1, 1481=>1, 1483=>1, 1487=>1, 1489=>1, 1493=>1, 1499=>1, 1511=>1, 1523=>1, 1531=>1, 1543=>1, 1549=>1, 1553=>1, 1559=>1, 1567=>1, 1571=>1, 1579=>1, 1583=>1, 1597=>1, 1601=>1, 1607=>1, 1609=>1, 1613=>1, 1619=>1, 1621=>1, 1627=>1, 1637=>1, 1657=>1, 1663=>1, 1667=>1, 1669=>1, 1693=>1, 1697=>1, 1699=>1, 1709=>1, 1721=>1, 1723=>1, 1733=>1, 1741=>1, 1747=>1, 1753=>1, 1759=>1, 1777=>1, 1783=>1, 1787=>1, 1789=>1, 1801=>1, 1811=>1, 1823=>1, 1831=>1, 1847=>1, 1861=>1, 1867=>1, 1871=>1, 1873=>1, 1877=>1, 1879=>1, 1889=>1, 1901=>1, 1907=>1, 1913=>1, 1931=>1, 1933=>1, 1949=>1, 1951=>1, 1973=>1, 1979=>1, 1987=>1, 1993=>1, 1997=>1, 1999=>1, 2003=>1, 2011=>1, 2017=>1, 2027=>1, 2029=>1, 2039=>1, 2053=>1, 2063=>1, 2069=>1, 2081=>1, 2083=>1, 2087=>1, 2089=>1, 2099=>1, 2111=>1, 2113=>1, 2129=>1, 2131=>1, 2137=>1, 2141=>1, 2143=>1, 2153=>1, 2161=>1, 2179=>1, 2203=>1, 2207=>1, 2213=>1, 2221=>1, 2237=>1, 2239=>1, 2243=>1, 2251=>1, 2267=>1, 2269=>1, 2273=>1, 2281=>1, 2287=>1, 2293=>1, 2297=>1, 2309=>1, 2311=>1, 2333=>1, 2339=>1, 2341=>1, 2347=>1, 2351=>1, 2357=>1, 2371=>1, 2377=>1, 2381=>1, 2383=>1, 2389=>1, 2393=>1, 2399=>1, 2411=>1, 2417=>1, 2423=>1, 2437=>1, 2441=>1, 2447=>1, 2459=>1, 2467=>1, 2473=>1, 2477=>1, 2503=>1, 2521=>1, 2531=>1, 2539=>1, 2543=>1, 2549=>1, 2551=>1, 2557=>1, 2579=>1, 2591=>1, 2593=>1, 2609=>1, 2617=>1, 2621=>1, 2633=>1, 2647=>1, 2657=>1, 2659=>1, 2663=>1, 2671=>1, 2677=>1, 2683=>1, 2687=>1, 2689=>1, 2693=>1, 2699=>1, 2707=>1, 2711=>1, 2713=>1, 2719=>1, 2729=>1, 2731=>1, 2741=>1, 2749=>1, 2753=>1, 2767=>1, 2777=>1, 2789=>1, 2791=>1, 2797=>1, 2801=>1, 2803=>1, 2819=>1, 2833=>1, 2837=>1, 2843=>1, 2851=>1, 2857=>1, 2861=>1, 2879=>1, 2887=>1, 2897=>1, 2903=>1, 2909=>1, 2917=>1, 2927=>1, 2939=>1, 2953=>1, 2957=>1, 2963=>1, 2969=>1, 2971=>1, 2999=>1, 3001=>1, 3011=>1, 3019=>1, 3023=>1, 3037=>1, 3041=>1, 3049=>1, 3061=>1, 3067=>1, 3079=>1, 3083=>1, 3089=>1, 3109=>1, 3119=>1, 3121=>1, 3137=>1, 3163=>1, 3167=>1, 3169=>1, 3181=>1, 3187=>1, 3191=>1, 3203=>1, 3209=>1, 3217=>1, 3221=>1, 3229=>1, 3251=>1, 3253=>1, 3257=>1, 3259=>1, 3271=>1, 3299=>1, 3301=>1, 3307=>1, 3313=>1, 3319=>1, 3323=>1, 3329=>1, 3331=>1, 3343=>1, 3347=>1, 3359=>1, 3361=>1, 3371=>1, 3373=>1, 3389=>1, 3391=>1, 3407=>1, 3413=>1, 3433=>1, 3449=>1, 3457=>1, 3461=>1, 3463=>1, 3467=>1, 3469=>1, 3491=>1, 3499=>1, 3511=>1, 3517=>1, 3527=>1, 3529=>1, 3533=>1, 3539=>1, 3541=>1, 3547=>1, 3557=>1, 3559=>1, 3571=>1, 3581=>1, 3583=>1, 3593=>1, 3607=>1, 3613=>1, 3617=>1, 3623=>1, 3631=>1, 3637=>1, 3643=>1, 3659=>1, 3671=>1, 3673=>1, 3677=>1, 3691=>1, 3697=>1, 3701=>1, 3709=>1, 3719=>1, 3727=>1, 3733=>1, 3739=>1, 3761=>1, 3767=>1, 3769=>1, 3779=>1, 3793=>1, 3797=>1, 3803=>1, 3821=>1, 3823=>1, 3833=>1, 3847=>1, 3851=>1, 3853=>1, 3863=>1, 3877=>1, 3881=>1, 3889=>1, 3907=>1, 3911=>1, 3917=>1, 3919=>1, 3923=>1, 3929=>1, 3931=>1, 3943=>1, 3947=>1, 3967=>1, 3989=>1, 4001=>1, 4003=>1, 4007=>1, 4013=>1, 4019=>1, 4021=>1, 4027=>1, 4049=>1, 4051=>1, 4057=>1, 4073=>1, 4079=>1, 4091=>1, 4093=>1, 4099=>1, 4111=>1, 4127=>1, 4129=>1, 4133=>1, 4139=>1, 4153=>1, 4157=>1, 4159=>1, 4177=>1, 4201=>1, 4211=>1, 4217=>1, 4219=>1, 4229=>1, 4231=>1, 4241=>1, 4243=>1, 4253=>1, 4259=>1, 4261=>1, 4271=>1, 4273=>1, 4283=>1, 4289=>1, 4297=>1, 4327=>1, 4337=>1, 4339=>1, 4349=>1, 4357=>1, 4363=>1, 4373=>1, 4391=>1, 4397=>1}
factors.length # => 599


# Lets calculate the unique combinations of notes we can play, based on these frequencies
# In retrospect, I think this is the same as just prime factorizing every number in the freq range, but Imma keep it for now
require 'set'

# array      - is assumed to be sorted ascendingly
# aggregate  - will accumulate some value as it traverses
# aggregator - receives aggregator and current value
#              returns the new aggregate and whether to prune (discontinue)
def unique_combinations(array, aggregate, all=Set.new, current=[], start=0, &aggregator)
  return all if array.length == start
  (1..array.length-start).flat_map do |offset|
    index = start + offset
    element              = array[index-1]
    nextaggregate, prune = aggregator.call(aggregate, element)
    break if prune
    combination          = [*current, element]
    unless all.include? combination
      all << combination
      unique_combinations(array, nextaggregate, all, combination, index, &aggregator)
    end
  end
  all
end


factor_array    = factors.flat_map { |factor, times| Array.new times, factor }
note_factors = unique_combinations(factor_array, 1) { |base_freq, factor|
    freq = base_freq*factor
    [freq, freq>highest_note]
  }
  .map { |factors| [factors.inject(1, :*), factors] }
  .sort_by(&:first).to_h

# This gives us these notes:
note_factors.length            # => 4399
note_factors.take(5).to_h      # => {2=>[2], 3=>[3], 4=>[2, 2], 5=>[5], 6=>[2, 3]}
note_factors.to_a.last(5).to_h # => {4396=>[2, 2, 7, 157], 4397=>[4397], 4398=>[2, 3, 733], 4399=>[53, 83], 4400=>[2, 2, 2, 2, 5, 5, 11]}


# So what notes sound good together? I think the relationship of interest is this:
#   Divide the common factors out of each
#   Then multiply the remaining number together
#   The smaller this number is, the better they sound (because they resonate over a shorter wavelength)
#   eg 100 vs 120 vs 100 and 125:
#     100 = 2*2*5*5
#     So which sounds better with the frequency of 100?
#       120 = 2*2*2*3*5
#          in common: 2*2*5 = 20
#          100 / 20 =  5
#          120 / 20 =  6
#          So first number that is a multiple of both: 20*5*6 = 600
#       125 = 5*5*5
#          in common: 5*5 = 25
#          100 / 25 = 4
#          120 / 25 = 5
#          4*5 = 20
#          So first number that is a multiple of both: 25*4*5 = 500
#     So 100Hz sounds better with 125Hz than with 120Hz
def smallest_multiple(a, b)
  1.upto(a*b).find { |n| n % a == 0 && n % b == 0 }
end
smallest_multiple 100, 120 # => 600
smallest_multiple 100, 125 # => 500

# Now lets find the harmonic notes
def time
  start = Time.now
  yield
  Time.now - start
end

def ratios_in(notes_to_factors)
  # using arrays b/c it is dramatically faster.
  # eg building this data structure with hashes takes about 6s, with arrays about 1.5s
  # this also speeds up the loop below

  notes = notes_to_factors.keys

  multiplier_matrix = []
  working_factors = []
  notes.each do |note1|
    working_factors[note1] = notes_to_factors[note1].dup
    multiplier_matrix[note1] = multipliers = []
    notes.each { |note2| multipliers[note2] = 1 }
  end

  factors = notes_to_factors.values.inject([], :|).sort
  factors.unshift :placeholder # to make it start empty

  loop do
    factor = factors[0]
    haves, havenots = notes.partition { |note| working_factors[note][0] == factor }

    if haves.empty?
      factors.shift
      break if factors.empty?
      puts "\e[44m MOVING ON TO #{factors[0]} \e[0m"
      next
    else
      puts "HAVES: #{haves.size}, HAVE NOTS: #{havenots.size}"
    end

    haves.each { |note| working_factors[note].shift }

    haves.each do |have|
      havenots.each do |havenot|
        multiplier_matrix[have][havenot] = multiplier_matrix[havenot][have] *= factor
      end
    end
  end

  result = {}
  multiplier_matrix.each_with_index do |multipliers, note1|
    next if multipliers.nil?
    chord_pairs = []
    multipliers.each_with_index { |multiplier, chord2| multiplier && chord_pairs << [chord2, multiplier] }
    chord_pairs.sort_by!(&:last)
    chord_pairs.shift # it will match itself, which is not a chord
    result[note1] = chord_pairs.to_h
  end
  result
end

require 'pp'
# maybe_good = ratios_in 100=>[2, 2, 5, 5],
#                           120=>[2, 2, 2, 3, 5],
#                           125=>[5, 5, 5],
#                           130=>[2, 5, 13]
# # => {100=>{125=>20, 120=>30, 130=>130},
# #     120=>{100=>30, 130=>156, 125=>600},
# #     125=>{100=>20, 120=>600, 130=>650},
# #     130=>{100=>130, 120=>156, 125=>650}}
# pp maybe_good

# # p time { ratios_in note_factors } # 32.92s

# def ratios_in(notes_to_factors)
#   all = []
#   notes_to_factors.keys.each do |note1|
#     note1r = note1.to_r
#     notes_to_factors.keys.each { |note2|
#       all << [note1r/note2, note1, note2]
#     }
#   end
#   all.sort_by! { |ratio| ratio[0] }
# end
# maybe_good = ratios_in 100=>[2, 2, 5, 5],
#                           120=>[2, 2, 2, 3, 5],
#                           125=>[5, 5, 5],
#                           130=>[2, 5, 13]
# # => {100=>{125=>20, 120=>30, 130=>130},
# #     120=>{100=>30, 130=>156, 125=>600},
# #     125=>{100=>20, 120=>600, 130=>650},
# #     130=>{100=>130, 120=>156, 125=>650}}
# pp maybe_good

# result = nil
# p time { result = ratios_in note_factors } # 41.53s
# require "pry"
# binding.pry

###########################################################


def ratios_in(notes_to_factors)
  # using arrays b/c it is dramatically faster.
  # eg building this data structure with hashes takes about 6s, with arrays about 1.5s
  # this also speeds up the loop below

  notes, gcd_matrix, working_factors = notes_to_factors.keys, [], []

  notes.each do |note1|
    working_factors[note1] = notes_to_factors[note1].dup
    gcd_matrix[note1]      = multipliers = []
    notes.each { |note2| multipliers[note2] = 1 }
  end

  factors = notes_to_factors.values.inject([], :|).sort
  factors.unshift :placeholder

  loop do
    factor = factors[0]
    haves, havenots = notes.partition { |note| working_factors[note][0] == factor }

    if haves.empty?
      factors.shift
      factors.empty? ? break : next
    end

    haves.each_with_index do |note1, index|
      working_factors[note1].shift
      haves.drop(index).each { |note2| gcd_matrix[note1][note2] = gcd_matrix[note2][note1] *= factor }
    end
  end

  result = {}
  gcd_matrix.each_with_index do |gcds, note1|
    next if gcds.nil?
    chord_pairs = []
    gcds.each_with_index { |gcd, note2| gcd && chord_pairs << [note2, [note2/gcd, note1/gcd]] }
    chord_pairs.sort_by! { |_note2, (_numerator, denominator)| denominator }
    chord_pairs.shift # don't have it match itself
    result[note1] = chord_pairs.to_h
  end
  result
end

actual = ratios_in(100  => [2, 2, 5, 5],
                   120  => [2, 2, 2, 3, 5],
                   125  => [5, 5, 5],
                   130  => [2, 5, 13],
                  )
expected = { 100 => {125=>[ 5,  4], 120=>[ 6,  5], 130=>[13, 10]},
             120 => {100=>[ 5,  6], 130=>[13, 12], 125=>[25, 24]},
             125 => {100=>[ 4,  5], 120=>[24, 25], 130=>[26, 25]},
             130 => {100=>[10, 13], 120=>[12, 13], 125=>[25, 26]},
           }

if actual != expected
  puts "EXPECTED"
  pp expected
  puts
  puts "ACTUAL"
  pp actual
  exit 1
else
  puts "\e[32mLooks good\e[39m"
end

result = nil
p time_to_generate: time { result = ratios_in note_factors } # 25.5s

require_relative 'lib/alternate_notes/persist'
p time_to_persist: time {
  AlternateNotes::Persist.dump_ratios(result, 'ratios.dump')
} # ~24s

# ~50s each
# p time_to_file_dump1: time { File.write "note_ratios.rbm", Marshal.dump(result) }
# p time_to_file_dump2: time {
#   File.open "note_ratios2.rbm", "w" do |file|
#     Marshal.dump result, file
#   end
# }
