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
    assert(LL::RegexToken.new(/[0-9]\:/) == '9:')
    assert(LL::RegexToken.new(/[0-9]\:/) == '1:')
  end

  def test_parser_with_regex

    counter = 0;
    
    rule1 = LL::Rule.new(:S, [:F])
    rule2 = LL::Rule.new(:S, ['(', :S, '+', :F, ')'])
      
    rule3 = LL::Rule.new(:F, [LL::RegexToken.new(/[0-9]/)]) do |t|
      $LOGGER.debug("CALLING RULE HANDLER FOR TOKEN #{t}")    
      counter += 1 
    end

    p = LL::Parser.new([rule1, rule2, rule3], false)

    p.parse('( 1 + 7 )') do |r, s, t |
      $LOGGER.debug("Expected #{s} found #{t} within Rule #{r.inspect}")    
    end

    assert(counter == 2)

  end
end
