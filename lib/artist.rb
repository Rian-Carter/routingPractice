class Artist
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def update(attributes)
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      @name = attributes.fetch(:name)
      DB.exec("UPDATE artists SET name = '#{@name}' WHERE id = #{@id};")
    elsif (attributes.has_key?(:album_name)) && (attributes.fetch(:album_name) != nil)
      album_name = attributes.fetch(:album_name)
      album = DB.exec("SELECT * FROM albums WHERE lower(name)='#{album_name.downcase}';").first
      if album != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{album['id'].to_i}, #{@id});")
      end
    end
  end

  def albums
    albums = []
    results = DB.exec("SELECT album_id FROM albums_artists WHERE artist_id = #{@id};")
    results.each() do |result|
      album_id = result.fetch("album_id").to_i()
      album = DB.exec("SELECT * FROM albums WHERE id = #{album_id};")
      name = album.first().fetch("name")
      albums.push(Album.new({:name => name, :id => album_id}))
    end
    albums
  end

  # def save
  #   results = DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES ('#{@album_id}', #{@artist_id}) RETURNING id;")
  #   @id = results.first().fetch("id").to_i
  # end
  def save
    results = DB.exec("INSERT INTO artists (name) VALUES ('#{@name}') RETURNING id;")
    @id = results.first().fetch("id").to_i
  end
  # def save
  #   result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
  #   @id = result.first().fetch("id").to_i
  # end

  def delete
    DB.exec("DELETE FROM albums_artists WHERE artist_id = #{@id};")
    DB.exec("DELETE FROM artists WHERE id = #{@id};")
  end

end