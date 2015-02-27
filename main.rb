require 'rubygems'
require 'sinatra'

# use Rack::Session::Cookie, :key => 'rack.session',
#                            :path => '/',
#                            :secret => 'secret' #'secret' can be any string

set :sessions, true                          

get '/' do #render text sample
	redirect '/set_name'
end

get '/set_name' do #templete sample
	erb :set_name_form
end

get '/nested_templete' do #nested_templete sample
	erb :"user/test"
end

post '/put_bet' do
	params['username']
	#erb :put_bet
end





