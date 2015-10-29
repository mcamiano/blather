autoload :HashChain, './lib/HashChain'
autoload :StringParser,          './lib/StringParser'

class Shruggles
  VERSION = "1.0.0"

  # whitespace of any kind as delimiter
  # contiguous word characters \w+ as word-tokens
  # quotes at sentence begining and end as separate tokens
  # sentence punctuation characters as sentence-end-token, sentence-begin-token
  # end of stream as sentence-end-token

  def train(str)
      if self.instance_variable_defined?(:@chain)
          @chain = HashChain.new(StringParser.new(str), from: @chain)
      else 
          @chain = HashChain.new(StringParser.new(str))
      end
  end

  def shrug(hash={})

      if hash.has_key?(:sentences)
          sentences = (1..hash[:sentences]).map{ @chain.sentences() }.join(" ") 
          yield(sentences) if block_given?
          return sentences
      end

      if hash.has_key?(:words)
          words = (1..hash[:words]).map{ @chain.word() }.join(" ") 
          yield(words) if block_given?
          return words
      end

  end

end

__END__
  
