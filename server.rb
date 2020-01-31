require 'sinatra'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

enable :sessions

# Any classes you add to the models folder will automatically be made available in this server file

get '/' do
  redirect '/starships'
end

get '/starships/new' do

  erb :'starships/new'
end

post '/starships' do
  name = params[:name]
  ship_class = params[:ship_class]
  location = params[:location]
  new_ship = Ship.create(
    name: name,
    ship_class: ship_class,
    location: location
  )
  if new_ship.save
    flash[:notice] = "You have successfully made a new ship!"
    redirect "/starships/#{new_ship.id}"
  else
    flash[:notice] = new_ship.errors.full_messages.to_sentence
    redirect "/starships/new"
  end
  @fail_message = "Fields cannot be blank!"
  @new_ship = Ship.find_by(name: params["name"])
end

post '/starships/:id' do
  @ship = Ship.find(params["id"])
  page = params["id"]
  first_name = params[:first_name]
  last_name = params[:last_name]
  specialty = params[:specialty]
  new_crew = CrewMember.new(
    first_name: first_name,
    last_name: last_name,
    specialty: specialty,
    ship_id: @ship.id
  )
  if new_crew.save
    flash[:notice] = "Success!"
    redirect "/crew-members"
  else
    flash[:notice] =  new_crew.errors.full_messages.to_sentence
    redirect "/starships/#{page}"
  end
  @fail_message = "Fields cannot be blank!"
end


get '/crew-members' do
  @crew = CrewMember.order(:last_name)
  erb :'/crew/index'
end

get '/starships' do
  @ships = Ship.all

  erb :'starships/index'
end

get '/starships/:id' do
  @ship = Ship.find(params["id"])
  @crew = CrewMember.where(ship_id: @ship.id)

  erb :'starships/show'
end

# Use a custom Starship class that inherits from ActiveRecord to retrieve your database objects
# You should be using ActiveRecord CRUD methods to aid you.
# E.g. Planet.where(planet_type: "gas giant"), etc.
