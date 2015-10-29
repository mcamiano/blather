#!/usr/bin/ruby
#
# whitespace of any kind as delimiter
# contiguous word characters \w+ as word-tokens
# sentence punctuation characters as sentence-end-token, sentence-begin-token
# end of stream as sentence-end-token

require "./lib/shruggles.rb"

abort("Usage: #{$PROGRAM_NAME} textfile\n") if ARGV.length != 1

shruggle = Shruggles.new

shruggle.train File.read(ARGV[0])

shruggle.shrug(sentences: 8) { |sentence| puts sentence }

__END__
