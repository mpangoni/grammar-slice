module LL
  class Rule

    attr_reader :non_terminal
    attr_reader :stack
    
    attr_reader :handler
    
    def initialize(non_terminal, stack, &handler)
      @non_terminal = non_terminal
      @stack = stack
      
      @handler = handler
    end

    def fire_handler( s, t )
      
      if @handler then
        @handler.call( s, t )          
      end
      
    end
    
  end
end