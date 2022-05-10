require('rspec')
require('pg')
require('album')
require('song')
require('pry')
require('./db_access.rb')


RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
  end
end