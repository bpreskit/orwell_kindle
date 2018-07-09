# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'uri'
require 'parallel'
require './genre'

$BASE_URL = 'http://orwell.ru/'

# class Genre
#   attr_accessor :name, :page
  
#   def initialize name, page
#     @name = name
#     @page = page
#   end

#   def build_genre name, page
#     @toc_entry = toc_init
#     @genre_text = genre_beginning

#     genre_links = @page.css('.s_list dd//a')
#     writings = Parallel.map_with_index(genre_links, :in_threads => 4) do |link, ind|
#       add_writing link, ind
#     end
#     finish_genre
#   end

#   def toc_init
#     "<li>" + "<a href=\"#genre_#{@name}\">" +
#       "<h3 class=\"genre_toc_head\">" +
#       @name + "</h3>" + "</a>" + "<ul>"
#   end

#   def genre_beginning
#     "<h1 class=\"genre_beginning\" id=\"genre_#{@name}\">" +
#                   @name + "</h1>"
#   end

#   def add_writing link, ind

#   end

#   def finish_genre
#     @toc_entry += ''
#   end
# end

genre_links = Nokogiri::HTML(open($BASE_URL + 'library/index_en/')).css('ol//li//a')

genres = Parallel.map_with_index(genre_links, :in_threads => 8) do |item, ind|
  index = ind - 1
  url = item['href']
  next if url =~ /novels|others/
  # unless url.ascii_only?
  #   url = URI.escape(url)
  # end
  genre_name = item.text.gsub("George Orwell's ", "").capitalize
  genre_page = Nokogiri::HTML(open($BASE_URL + url))
  genre = Genre.new genre_name, genre_page

  # writings = genre_page.css('.s_list dd//a').collect { |link| link['href']}
  

  # chapter_title = doc.css('h1.pjgm-posttitle').first

  # #modify chapter to have link
  # chapter_title_plain = chapter_title.content
  # $stderr.puts chapter_title_plain
  # chapter_content = doc.css('div.pjgm-postcontent').first #gsub first p
  # #clean
  # chapter_content.search('.//div').remove
  # to_remove = doc.css('div.entry-content p').first #gsub first p
  # chapter_content = chapter_content.to_s.gsub(to_remove.to_s,"")
  # #write
  # {"body" => "<h1 id=\"chap#{index.to_s}\">#{chapter_title_plain}</h1>" + chapter_content,
  #  "toc" => "<a href=\"#chap#{index.to_s}\">#{chapter_title_plain}</a><br>"}
end#.select {|chapter| chapter}

# @toc = "<h1>Table of Contents</h1>"
# @book_body = ""

# chapters.each do |chapter|
#   @book_body << chapter["body"]
#   @toc << chapter["toc"]
# end

# $stderr.puts "Writing Book..."

# puts @toc
# puts @book_body
