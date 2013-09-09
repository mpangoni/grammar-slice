require 'logger'

require 'LL_rule'
require 'LL_regex_token'

module LL

  class Parser
    
    def initialize(rules, resilient=true)

      @table = build_table(rules)
      @start_rule = rules[0]
      @resilient = resilient
      
    end

    def parse( stream, &handler )

      rule = @start_rule
      
      stack = start_parse_stack(@start_rule)
      tokens = stream.split()
      
      p=0;

      while(stack.size() > 0)

        # Is token equal to current stack's item ?
        if  stack.last() == tokens[p]  then

          # call a 'global' parse handler
          if handler then
            handler.call(rule, stack.last(), tokens[p])
          end
          
          # try to call rule handler
          rule.fire_handler( stack.last(), tokens[p])
          
          p = p + 1
          stack.pop()

        # if expected token wont match with current stack's token, try to find a new 
        # rule in table and push each token to stack
        else

          $LOGGER.debug("Finding rule for #{stack.last().to_s}  and token #{tokens[p]}")

          rule  = @table[[stack.last(), tokens[p]] ]

          # throw some error if cant find a rule and parser is not resilient
          raise "Unexpected token " + tokens[p] if !rule and !@resilient

          # just return if cant find rule and parser is resilient
          return if !rule and @resilient
          
          stack.pop
          rule.stack.reverse.each {|v| stack.push(v) }

        end

      end

    end

    def build_table(rules)

      parse_table = Hash.new

      # for each rule get non terminal and first symbol
      # and build a map like {[:S,first_symbol] => rule}
      rules.each do |r|

        non_terminal = r.non_terminal
        first_symbol = r.stack[0]

        #if first symbol refers to a inner rule
        #try get his firts symbol to build parse table
        if first_symbol.kind_of?(Symbol) then

          $LOGGER.debug("First Symbol " + first_symbol.to_s + " reffers to a rule")

          inner_rules = find_firts_symbol(first_symbol, rules)

          $LOGGER.debug("Found a rule " + inner_rules[0].inspect)

          first_symbol = inner_rules[0].stack[0]

        end

        key = [non_terminal, first_symbol]
        parse_table[key] = r

      end

      $LOGGER.debug( "parse table is : \n#{parse_table.inspect}" )

      return parse_table

    end

    def start_parse_stack(rule)
      stack = Array.new
      stack.pop()
      #     @stack.push(:END_OF_STREAM)
      stack.push(rule.non_terminal)
    end
    
    def find_firts_symbol(s, rules)
      rules.select { |r| r.non_terminal == s and !(r.stack[0].kind_of?(Symbol)) }
    end

    
  end
end