module LL

  class RegexToken
    
    def initialize(regex)
      @regex = regex
    end

    def ==(other)
      @regex =~ other
    end
    
  end

end