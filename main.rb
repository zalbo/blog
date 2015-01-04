require 'rubygems'
require 'bundler/setup'

require 'sinatra'
configure { set :server, :puma }

get '/' do
  erb :index
end

get '/:filter' do
  @filter = params[:filter]
  puts @filter
  erb :index
end

