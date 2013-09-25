module LL
  class Rule

    attr_reader :non_terminal
    attr_reader :first_symbol
        
    def initialize(non_terminal, stack, &handler)
      @non_terminal = non_terminal
      @first_symbol = stack[0]
      
      @stack = stack
      @handler = handler
    end
    
    def push(stack)
      @stack.reverse.each do |v| 
        
        if !v.kind_of?(Symbol) and @handler then
          $LOGGER.debug("Adding Handler #{@handler} to symbol #{v}")
          
          def v.fire(token)
            $LOGGER.debug("Executing #{@handler} to symbol #{v} with token #{token}")
            @handler.call(token)
          end
        end
        
        stack.push(v)
      end
    end    
  end
end