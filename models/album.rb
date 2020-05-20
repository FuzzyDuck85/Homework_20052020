require_relative('../db/sql_runner')
require_relative('./artist.rb')

class Album

  attr_accessor :title, :genre, :released, :artist_id
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @genre = options['genre']
    @released = options['released'].to_i
    @artist_id = options['artist_id'].to_i
    @id = options['id'].to_i if options['id']
  end

  def artist()
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@artist_id]
    results = SqlRunner.run(sql, values)
    artist_hash = results[0]
    artist = Artist.new(artist_hash)
    return artist
  end

  def save()
    sql = "INSERT INTO albums
    (
      title,
      genre,
      released,
      artist_id
    ) VALUES
    (
      $1, $2, $3, $4
    )
    RETURNING id"
    values = [@title, @genre, @released, @artist_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def update()
    sql = "
    UPDATE albums SET (
      title,
      genre,
      released,
      artist_id
    ) =
    (
      $1,$2, $3, $4
    )
    WHERE id = $5"
    values = [@title, @genre, @released, @artist_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM albums where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.find(id)
    sql = "SELECT * FROM albums WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    album_hash = result.first
    album = Album.new(album_hash)
    return album
  end

  def self.delete_all()
    sql = "DELETE FROM albums"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM albums"
    pg_results = SqlRunner.run(sql)
    return albums.map { |album| Album.new(album) }
  end

end
