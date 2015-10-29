gem "minitest"
require "minitest/autorun"
require "shruggles"

class TestShruggles < Minitest::Test
  def setup
    @shruggle = Shruggles.new
    @shruggle.train File.read("test/_data/fixture1.txt")
  end
  def test_sentence
    sentences = @shruggle.shrug(sentences: 2)

    assert  %r[\([^.]+.\)+] , sentences
  end
end
