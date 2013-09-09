require 'logger'
require 'test/unit'

require 'LL_parser'

if !$LOGGER
  $LOGGER = Logger.new(STDOUT)
  $LOGGER.level = Logger::DEBUG
end

class TestLLParser < Test::Unit::TestCase
  def test_simple_expression

    counter = 0;
    
    rule1 = LL::Rule.new(:S, [:F])
    rule2 = LL::Rule.new(:S, ['(', :S, '+', :F, ')'])
    rule3 = LL::Rule.new(:F, ['a'])

    p = LL::Parser.new([rule1, rule2, rule3])

    p.parse('( a + a )') do |r, s, t | 
      $LOGGER.debug("Expected #{s} found #{t}")
    
      counter += 1 if t == 'a'
    end

    assert(counter == 2)
  end

  def test_complex_expression

    counter = 0;
    
    rule1 = LL::Rule.new(:S, [:F])
    rule2 = LL::Rule.new(:S, ['(', :S, '+', :F, ')'])
    rule3 = LL::Rule.new(:F, ['a'])

    p = LL::Parser.new([rule1, rule2, rule3])

    p.parse('( ( a + a ) + a )') do |r, s, t | 
       $LOGGER.debug("Expected #{s} found #{t}") 
       counter += 1 if t == 'a'
    end
    
    assert(counter == 3)
      
  end

end
