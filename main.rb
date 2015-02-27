require 'rubygems'
require 'sinatra'
require 'pry'

# use Rack::Session::Cookie, :key => 'rack.session',
#                            :path => '/',
#                            :secret => 'secret' #'secret' can be any string

set :sessions, true   

helpers do 
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

  def card_image(card) #['Heart_', 4]
  	suits = card[0]

  	value = case card[1]
  		when 'A' then 'ace'
  		when 'J' then 'jack'
  		when 'Q' then 'queen'
  		when 'K' then 'King'
  		else
  			card[1].to_s
  	end
  	"<img src='/images/cards/#{suits}#{value}.jpg'>"
  end
end    

before do
	@show_button = true
	@uncover = false
end                   

get '/' do 
	redirect '/set_name'
end

get '/set_name' do 
	erb :set_name_form
end

post '/set_name' do
	session[:username] = params[:username]
	if session[:username] == ""
		@error = "Please enter your name again"
		erb :set_name_form
	else
		redirect '/game'
	end
end

get '/game' do
	value = ["A",2,3,4,5,6,7,8,9,10,"J","Q","K"]
  suits = ['hearts_', 'spades_', 'diamonds_', 'clubs_']
	session[:deck] = suits.product(value).shuffle!
	session[:player_cards] = []
	session[:dealer_cards] = []
	session[:player_cards] << session[:deck].pop
	session[:dealer_cards] << session[:deck].pop
	session[:player_cards] << session[:deck].pop
	session[:dealer_cards] << session[:deck].pop
	erb :game
end

post '/game/player/hit' do
	session[:player_cards] << session[:deck].pop
	player_total = count_score(session[:player_cards])
	redirect '/game/result' if player_total >= 21
	erb :game
end

post '/game/player/stay' do
	redirect '/game/dealer'
end

get '/game/dealer' do
	dealer_total = count_score(session[:dealer_cards])
	redirect '/game/result' if dealer_total >= 17
	@show_button = false
	@uncover = true
	@dealer_turn = true

	erb :game
end

post '/game/dealer' do 
	session[:dealer_cards] << session[:deck].pop
	redirect 'game/dealer'
end

get '/game/result' do 
	@show_button = false
	@uncover = true
	@play_again = true
	dealer_total = count_score(session[:dealer_cards])
	player_total = count_score(session[:player_cards])
	if player_total == 21
		@win = "Congras, You hit blackjack!!"
	elsif player_total > 21
		@lose = "Sorry, you busted"
	elsif dealer_total == 21
		@lose = "Dealer hits blackjack, you lose"
	elsif dealer_total > 21
		@win = "Dealer busted, you won!!"
	elsif dealer_total > player_total
		@lose = "Dealer's total is greater than yours, you lose."
	elsif dealer_total < player_total
		@win = "Your total is greater than dealer's, you won!!"
	else
		@win = "IT's a tie."
	end
	erb :game
end

get '/game_over' do
	erb :game_over
end








