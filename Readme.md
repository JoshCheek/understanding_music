Alternate Music Notes
=====================

What is sound?
--------------

Sound is the vibration of air molecules.
When the air vibrates near your ear,
your ear senses this and relays the information to your brain by sending electrical signals to it.
Your brain then interprets these signals into sound, this is what hearing is.

When the air vibrates, it is moving back and forth. It may move against your eardrum,
creating pressure which you sense, and then move away from your eardrum, creating a
release in pressure, which you also sense.

If you were to graph the pressure that the molecules exert on your ear,
you would end up with

FIXME
  volume/amplitude (measured in decibals)
  pitch/frequency (measured in Hz)


What notes sound good together?
-------------------------------

When we put several notes together, this is called a chord.
You'll find that you can't put just any notes together and have it sound good.
There are some notes that sound good together and others which don't.
Thus, there are some chords which are very common, and others which are never used.

The Axis of Awesome has a song, ["Four Chords"](https://www.youtube.com/watch?v=oOlDewpCfZQ)
where they show that there are 4 chords that are so common,
you can play a large number of well known songs using just these chords.

Those notes sound good together because they vibrate at specific ratios,
relative to each other. This means that when the air molecules vibrate,
they vibrate in harmony.

Lets take an example of 110Hz. Say we were to multiply this by 4 to get 440Hz.

```ruby
110 * 4 # => 440
110 * 5 # => 550
110 * 6 # => 660
```

So we can see that the 440 will oscilate 4 times for every 5 that the 550 oscilates.
And it will oscilate 4 times for every 6 that the 660 oscilates,
which is the same as 2 times for every 3 that the 660 oscilates.
It takes just a few oscillations for them to line up harmoniously.

What about notes that don't sound good together?

```ruby
55 * 9  # => 440
55 * 10 # => 495
```

Here, the 440

So we can see that to get from 440 to 550, we would have to divide by 4 to get
down to 110, and then multiply by 5 to get up to 550.

and also by 5 to get 550Hz. To bring these two notes together, we would have to
multiply the 440 by 5

For example, The note `A` at 440Hz will sound good with the note `C#` at 550Hz.
This is because every 5 vibrations of the `A`, the `C#` will vibrate 4 times.

Here's how to figure that out: First, find all the prime factors of the numbers:

```ruby
2 * 2 * 2 * 5 * 11 # => 440
2 * 5 * 5 * 11     # => 550
```

Which factors do they have in common? The 2, 5, and 11.
So their greatest common divisor (GCD) is `2*5*11 # => 110`.
What leftover multiple does the 440 have? `440/110 # => 5`,
so that's what the `550` will need to account for,
hence it repeats 5 times.
so the 550 needs to
So the 550 will have to

The Notes On a Piano
--------------------

On a piano, the notes have these ratios:

```
 do |  re |  mi |  fa |  so |  la |   ti | do
----+-----+-----+-----+-----+-----+------+----
  1 | 9/8 | 5/4 | 4/3 | 3/2 | 5/3 | 15/8 |  2
```

We can map them to specific notes, lets make `do` the `A` note:

```
 do |  re |  mi |  fa |  so |  la |   ti | do
----+-----+-----+-----+-----+-----+------+----
  1 | 9/8 | 5/4 | 4/3 | 3/2 | 5/3 | 15/8 |  2
  A |   B |  C# |   D |   E |  F# |   G# |  A
```

The first note, with a ratio of 1 (the `do`, or `A` here), is called the root note.
We see that when the ratio is a multiple of the root note, it is the same note
(the second `do`/`A`, with a ratio of 2).

Each of these ratios will then repeat for the multiple.
The notes from the root note to its multiple of `2` is called an "octave".
So our chart displays one octave.

Here are the `A` octaves:

```ruby
lowest_note_h = 55
highest_a = lowest_note_h *  # => 55
                        2 *  # => 110
                        2 *  # => 220
                        2 *  # => 440
                        2 *  # => 880
                        2 *  # => 1760
                        2    # => 3520
```

The highest note on the piano is the `C#` above that highest `A`.
Its frequency is:

```ruby
# From the highest A (3520), we can get to the highest note (C#)
highest_a * 5 / 4 # => 4400
```

The Problem With This System
----------------------------

FIXME

Harmonic Tuning vs Equal Tempered Tuning
----------------------------------------

FIXME

```ruby
lowest_a  = 55
highest_a = lowest_a * (2**6) # => 3520

# From the highest A (3520), we can get to the highest note (C#)
highest_note_et = highest_a * (2**(3.0/12)) # => 4186.009044809578
highest_note_h  = highest_a * 5 / 4         # => 4400

# harmonic tuning vs equal tempered tuning (slightly flat)
highest_note_h  / highest_a.to_f  # => 1.25
highest_note_et / highest_a.to_f  # => 1.189207115002721
```


Lets Make Our Own Notes
-----------------------

Lets try to find an alternative set of frequencies that we could tune the piano to.
This is probably an exercise in futility, b/c surely more knowledgable and
competent humans than us have already tried it, but nonetheless, it's an
interesting exercise and helps us understand why things are the way they are.

We'll use the current lowest note as our lower-bound, and the current highest note
as our upper-bound. Our approach will be to find the ratios of each note to eachother,
and see if we can't identify a set of notes that all sound good together,
based on their harmonic relationships.

