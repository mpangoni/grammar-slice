module LL
  class Table
    def initialize(rules)
      @tree = {}

      # for each rule get non terminal and first symbol
      # and build a map like {[:S,first_symbol] => rule}
      rules.each do |r|

        non_terminal = r.non_terminal
        first_symbol = r.first_symbol

        #if first symbol refers to a inner rule
        #try get his firts symbol to build parse table
        if first_symbol.kind_of?(Symbol) then

          $LOGGER.debug("First Symbol " + first_symbol.to_s + " refers to a rule")

          inner_rules = find_firts_symbol(first_symbol, rules)

          $LOGGER.debug("Found a rule " + inner_rules[0].inspect)

          first_symbol = inner_rules[0].first_symbol

        end
        
        if @tree.has_key?(non_terminal) then
          @tree[non_terminal][first_symbol] = r
        else 
          @tree[non_terminal] = {first_symbol => r}        
        end

      end

      $LOGGER.debug( "parse table is : \n#{@tree.inspect}" )

    end

    def find_rule(s, t)
      @tree[s].each do |first_symbol, rule|
        return rule if first_symbol == t
      end
      
      return nil
    end

    def find_firts_symbol(s, rules)
      rules.select { |r| r.non_terminal == s and !(r.first_symbol.kind_of?(Symbol)) }
    end

  end

end