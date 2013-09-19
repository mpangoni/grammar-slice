module LL

  class ContextToken
    
    def initialize(list_of_values)
      @context = regex
    end

    def ==(other)
      @context.include? other
    end
    
  end
  
  def to_s
    @context.inspect
  end
end