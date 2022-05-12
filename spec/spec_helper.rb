require('rspec')
require('pg')
require('album')
require('song')
require('artist')
require('pry')
require('./db_access.rb')


RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
    DB.exec("DELETE FROM artists *;")
  end
end