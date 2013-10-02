module LL

  class RegexToken
    
    attr_reader :match
    
    def initialize(regex)
      @regex = regex
    end

    def ==(other)
      @regex =~ other
      @match = $~
    end
        
    def to_s
      @regex.to_s
    end
    
  end
  
end