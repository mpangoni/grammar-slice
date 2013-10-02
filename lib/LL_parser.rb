require 'logger'
require 'LL_table'
require 'LL_rule'
require 'LL_regex_token'

module LL
  class Parser
    def initialize(rules, resilient=true)

      @table = LL::Table.new(rules)
      @resilient = resilient

    end

    def parse( stream, &handler )

      rule = @table.

      stack = start_parse_stack(@start_rule)
      tokens = stream.split()

      p=0;

      while(stack.size() > 0)

        current_symbol = stack.last()
        
        # Is token equal to current stack's item ?
        if  current_symbol == tokens[p]  then

          # call a 'global' parse handler
          if handler then
            handler.call(rule, stack.last(), tokens[p])
          end

          # try to call rule handler
          current_symbol.fire(tokens[p]) if current_symbol.respond_to? :fire

          p = p + 1
          stack.pop()

          # if expected token wont match with current stack's token, try to find a new
          # rule in table and push each token to stack
        else

          $LOGGER.debug("Finding rule for #{current_symbol.to_s}  and token #{tokens[p]}")

          rule  = @table.find_rule( current_symbol, tokens[p] )

          # throw some error if cant find a rule and parser is not resilient
          raise "Unexpected token " + tokens[p] if !rule and !@resilient

          # just return if cant find rule and parser is resilient
          return if !rule and @resilient

          stack.pop
          
          $LOGGER.debug("Current rule #{rule.inspect}")
          
          rule.push(stack)

        end

        $LOGGER.debug("Current stack: #{stack.inspect}")

      end

    end

    def start_parse_stack(rule)
      stack = Array.new
      stack.pop()
      #     @stack.push(:END_OF_STREAM)
      stack.push(rule.non_terminal)
    end

  end
end