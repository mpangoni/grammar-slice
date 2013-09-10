module LL

  class RegexToken
    
    def initialize(regex)
      @regex = regex
    end

    def ==(other)
      @regex =~ other
    end
    
  end
  
  def to_s
    @regex.to_s
  end
end