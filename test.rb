  def count_score(own_card) #own_card will be either session[:player_cards] or session[dealer_cards] 
    score = 0
    card_value = []
    own_card.each do |card|
      if card[1] == "A" 
        score += 1
      elsif card[1].class == Fixnum
        score += card[1]
      else
        score += 10
      end  
      card_value << card[1]
    end
    score += 10 if score <= 11 && card_value.include?("A")
    score
  end

arr = [['H','A'],['D',8]]
puts  count_score(arr)