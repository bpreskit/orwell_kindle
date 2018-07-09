require 'nokogiri'
require 'open-uri'
require 'uri'
require 'parallel'
require './genre'

$BASE_URL = 'http://orwell.ru/'

genre_links = Nokogiri::HTML(open($BASE_URL + 'library/index_en/')).css('ol//li//a')

writings_all_str = ""

genre_links.each do |item|
    url = item['href']
  next if url =~ /novels|others/
  genre_name = item.text.gsub("George Orwell's ", "").capitalize
  genre_page = Nokogiri::HTML(open($BASE_URL + url))
  genre = Genre.new genre_name, genre_page
  writings_all_str += genre.genre_text
end
File.open('writings_all.html', 'w') { |file| file.write(writings_all_str)}
system "ebook-convert writings_all.html writings_all.mobi --authors \"George Orwell\" --title \"George Orwell's Writings\" --level1-toc //h:h1 --level2-toc //h:h2 --max-toc-links 512 --toc-threshold 256"
