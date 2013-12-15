# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


require 'pry'
require 'nokogiri'
require 'open-uri'

def scrape
  doc = Nokogiri::HTML(open('http://www.learnthat.org/pages/view/roots.html'))
  row_list = doc.css('.root_meanings tbody').children
  row_list.each_with_index do |row, i|
    next if i == 0
    scrape_row(row)
  end  
end

def scrape_row(row)
  if row.children[2].css('span').first.nil?
    root = row.children[2].css('strong').first.text
  else
    root = row.children[2].css('span').first.text
  end
  meanings = row.children[4].to_html.match(/>(.*)</).captures.first
  unless row.children[6].to_html.match(/>(\w+)</).nil?
    origin = row.children[6].to_html.match(/>(\w+)</).captures.first
  else
    origin = nil
  end

  r = Root.new(root_db: root, meaning: meanings, origin: origin)

  link = row.to_html.match(/(word_lists\/view\/\d*)/).captures.first
  derived_words = scrape_words(link)

  r.words.concat(derived_words) 
  r.save
  puts 'SSSSSAAAAAAAAAAVVVVVVVVVVEEEEEEEEEED'
end

def scrape_words(link)
  doc = Nokogiri::HTML(open("http://www.learnthat.org/#{link}"))
  words = doc.css('.chapter_words').map{|elem| elem.text}.join
  derived_words = []

  words = words.split(',').map{|word| word.strip}
  words = words.map do |word|
    puts word
    Word.where(word: word).first || Word.new(word: word)
  end  
  words
end

scrape
