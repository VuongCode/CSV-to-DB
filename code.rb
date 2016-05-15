#YOUR CODE GOES HERE
require 'pg'
require 'csv'

system "psql ingredients < schema.sql"

def db_connection
  begin
    connection = PG.connect(dbname: "ingredients")
    yield(connection)
  ensure
    connection.close
  end
end

CSV.foreach('ingredients.csv', headers: false) do |item|
  result = nil
  db_connection do |conn|
    result = conn.exec("INSERT INTO ingredients (name) VALUES ('#{item[0]}. #{item[1]}')")
  end
end

ingredient_list = db_connection do |conn|
  conn.exec("SELECT name FROM ingredients")
end

ingredient_list.to_a.each do |ingredient|
  puts ingredient["name"]
end
