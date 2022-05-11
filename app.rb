require('pg')
require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('./lib/song')
require('./lib/artists')
require('pry')
require('./db_access.rb')
also_reload('lib/**/*.rb')

# DB = PG.connect({:dbname => "record_store"})

get('/test') do
  @something = "this is a variable"
  erb(:whatever)
end

get('/') do
  # "This will be our home page. '/' is always the root route in a Sinatra application."
  @albums = Album.all
  erb(:albums)
end

get('/albums') do
  # redirect "/public/test"
  # "This route will show a list of all albums."
  # binding.pry
  @albums = Album.all
  erb(:albums)
end


get('/albums/new') do
  # "This will take us to a page with a form for adding a new album."
  erb(:new_album)
end

get('/albums/:id') do
  # "This route will show a specific album based on its ID. The value of ID here is #{params[:id]}."
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

post('/albums') do
  name = params[:album_name]
  album = Album.new(name, nil)
  album.save()
  @albums = Album.all() #Adding this line will the error
  erb(:albums)
  # "This route will add an album to our list of albums. We can't access this by typing in the URL. In a future lesson, we will use a form that specifies a POST action to reach this route."
end

get('/albums/:id/edit') do
  # "This will take us to a page with a form for updating an album with an ID of #{params[:id]}."
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  # variable1 = postvar['albumname'];
  # varble2 = postvar['artist'];
  # call some_update_function($post);
  # "This route will update an album. We can't reach it with a URL. In a future lesson, we will use a form that specifies a PATCH action to reach this route."
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name])
  @albums = Album.all
  erb(:albums)
end

delete('/albums/:id') do
  # call some_delete_function($post);
  # "This route will delete an album. We can't reach it with a URL. In a future lesson, we will use a delete button that specifies a DELETE action to reach this route."
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/artists')
  @artists = Artist.all
  erb(:artists)
end


