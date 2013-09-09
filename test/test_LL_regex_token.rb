require 'logger'
require 'test/unit'

require 'LL_parser'

if !$LOGGER
  $LOGGER = Logger.new(STDOUT)
  $LOGGER.level = Logger::DEBUG
end

class TestRegexToken < Test::Unit::TestCase
 
  def test_simple_regex
    assert(LL::RegexToken.new(/.*/) == 'teste')
  end

  def test_complex_regex
    assert(LL::RegexToken.new(/.*\:/) == 'teste:')
    assert(LL::RegexToken.new(/[0..9]\:/) == '9:')
  end

  def test_parser_with_regex

    counter = 0;
    
    rule1 = LL::Rule.new(:S, [:F])
    rule2 = LL::Rule.new(:S, ['(', :S, '+', :F, ')'])
      
    rule3 = LL::Rule.new(:F, [LL::RegexToken.new(/[0..9]/)]) { counter += 1 }

    p = LL::Parser.new([rule1, rule2, rule3], false)

    p.parse('( 9 + 7 )') do |r, s, t |
      $LOGGER.debug("Expected #{s} found #{t}")    
    end

    assert(counter == 2)

  end
end
