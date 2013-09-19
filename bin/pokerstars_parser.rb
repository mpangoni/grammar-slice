require 'LL_parser'

rule_hand_info = LL::Rule.new(:HAND_INFO, ['PokerStars', 'Hand', :HAND_ID])
rule_table_info = LL::Rule.new(:TABLE_INFO, ['Table', :TABLE_ID, :TABLE_SIZE, 'Seat', :BUTTON, 'is', 'the', 'button'])
rule_seat_info = LL::Rule.new(:SEAT_INFO, [])
rule_blinds_posts = LL::Rule.new(:BLINDS_POSTS, [])

rule_hand_step = LL::Rule.new(:HAND_STEP, [])
rule_player_action = LL::Rule.new()

rule_action_call = nil
rule_action_check = nil
rule_action_fold = nil
rule_action_raise = nil

#Create parser instance
all_rules = [rule_hand_info, rule_table_info, rule_seat_info, rule_blinds_posts, 
  rule_hand_step, rule_player_action, rule_action_call, rule_action_check, rule_action_fold, rule_action_raise]
parser = LL::Parser.new(all_rules)

#Parse all pokerstars files
files = Dir.entries('./hands/')

files.each do |file|

  if file =~ /.*\.txt/ then
        
    File.open( "./hands/#{file}" ) do |input|

      while !(line = input.gets).nil?
        parser.parse line
      end

    end

  end

end   