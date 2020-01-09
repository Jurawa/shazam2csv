#!/usr/bin/env ruby

require 'sqlite3'
require 'awesome_print'
require 'json'
require 'pry'
require 'csv'

db = SQLite3::Database.new "/Users/jurawa/Library/Group\ Containers/4GWDBCF5A4.group.com.shazam/com.shazam.mac.Shazam/ShazamDataModel.sqlite", results_as_hash: true

rows = []
search_links = []
csv_file = "/Users/jurawa/Downloads/shazams-#{Time.now.strftime('%Y-%m-%e %H.%M')}.csv"

db.execute( "select * from ZSHTAGRESULTMO" ) { |row| rows.push row }

CSV.open(csv_file, "w") do |csv|
  csv << %w(Title Artist GoogleSearchLink)

  rows.map do |row|
    heading = JSON.parse(row['ZTRACKJSON'])['track']['heading']
    title = heading['title']
    artist = heading['subtitle']
    search_link = "https://www.google.com/search?q=#{title}+#{artist}".gsub(' ', '+')
    csv << [title, artist, search_link]
  end  # ...
end

puts "Saved CSV! #{csv_file}"
