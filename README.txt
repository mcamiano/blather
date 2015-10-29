= shruggles

home  :: https://github.com/mcamiano/shruggles
code  :: https://github.com/mcamiano/shruggles
rdoc  :: https://github.com/mcamiano/shruggles
bugs  :: https://github.com/mcamiano/shruggles

== DESCRIPTION:

Shruggles generates texts that mimic the distribution of word-to-word transitions found in sampled input texts.

Shruggles uses a hash as a directed graph with integer weighted edges to represent a Markov chain. 
The weight of an edge is the frequency with which one token follows another.

Hash keys are words or other punctuation tokens; edges are tokens that immediately follow.
Sentence begin and end are counted as special tokens.

The transition probability is taken as the weight of an edge over the sum of the weights of all edges at the node.

The gem was originally named "blather," but that is a popular name for speech and text projects, 
and there is already a Markov chain project in node.js under that name. I was inspired by @mdwheele 
suggesting I take a look at a PHP Markov Chain text generator. At the time the word "shruggles" was being used to 
denote emo struggles combined with shrugs. Shruggles seemed an even better working title for the project,
and hadn't yet been used once on Github.

== FEATURES/PROBLEMS:

Shruggles is trained by parsing sample texts. Shruggles then generates meaningless sentences using the probabilities derived from the sample.

The internal representation of the Markov chain is a flat hash keyed by token, with each element pointing to a hash of weights keyed by the following tokens ([followingToken]=>weight).

Right now the gem makes a lot assumptions about text, mainly that it is relatively close to plain English text.

Repeated calls Shruggles#train continue to build out the chain.

It isn't quite done yet. Wants:
- persist the training to a serialized format, perhaps json, so it can be read back in
- finish up the gem packaging 
- test it for edge case behavior; it should at least fail gracefully
- improve handling of quotation punctuations


== SYNOPSIS:

  require "shruggles"
  shruggle = Shruggles.new
  shruggle.train File.read('test/_data/fixture1.txt')
  shruggle.shrug(sentences: 5) { |sentence| puts sentence }

== REQUIREMENTS:

* n/a

== INSTALL:

* sudo gem install shruggles

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

(The MIT License)

Copyright (c) 2015 Mitchell C. Amiano

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
