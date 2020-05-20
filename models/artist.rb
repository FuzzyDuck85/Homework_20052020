require('pg')
require_relative('../db/sql_runner.rb')
require_relative('./album.rb')

class Artist

attr_reader :id
attr_accessor :name

def initialize(options)
  @id = options['id'].to_i if options['id']
  @name = options['name']
end

def album()
  sql = "SELECT * FROM albums
  WHERE artist_id = $1"
  values = [@id]
  album_hashes = SqlRunner.run(sql, values)
  album_objects = album_hashes.map { |album_hash| Album.new(album_hash) }
  return album_objects
end

def save()
  sql = "INSERT INTO artists (name) VALUES ($1)
  RETURNING id"
  values = [@name]
  @id = SqlRunner.run(sql, values)[0]['id'].to_i
end

def update()
  sql = "
  UPDATE artists SET (name) = ($1) WHERE id = $2"
  values = [@name, @id]
  SqlRunner.run(sql, values)
end

def delete()
  sql = "DELETE FROM artists where id = $1"
  values = [@id]
  SqlRunner.run(sql, values)
end

def self.find(id)
  sql = "SELECT * FROM artists WHERE id = $1"
  values = [id]
  db.prepare("find", sql)
  results = SqlRunner.run(sql, values)
  db.close()
  artist_hash = results.first
  artist = Customer.new(artist_hash)
  return artist
end

def self.delete_all()
  sql = "DELETE FROM artists"
  SqlRunner.run(sql)
end

def self.all()
  sql = "SELECT * FROM artists"
  artists = SqlRunner.run(sql)
  return artists.map {|artist| Customer.new(artist)}
end

end
