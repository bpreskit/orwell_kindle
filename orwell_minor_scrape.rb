# encoding: utf-8

require 'nokogiri'
require 'open-uri'
require 'uri'
require 'parallel'

base_url = 'http://orwell.ru/'

genre_links = Nokogiri::HTML(open(base_url + 'library/index_en/')).css('ol//li')

genres = Parallel.map_with_index(genre_links, :in_threads => 8) do |item, ind|
  index = ind - 1
  url = item.at_css('a')['href']
  next if url =~ /novels|others/
  # unless url.ascii_only?
  #   url = URI.escape(url)
  # end
  genre_page = Nokogiri::HTML(open(base_url + url))

  writings = genre_page.css('.s_list dd//a')
  chapter_title = doc.css('h1.pjgm-posttitle').first

  #modify chapter to have link
  chapter_title_plain = chapter_title.content
  $stderr.puts chapter_title_plain
  chapter_content = doc.css('div.pjgm-postcontent').first #gsub first p
  #clean
  chapter_content.search('.//div').remove
  to_remove = doc.css('div.entry-content p').first #gsub first p
  chapter_content = chapter_content.to_s.gsub(to_remove.to_s,"")
  #write
  {"body" => "<h1 id=\"chap#{index.to_s}\">#{chapter_title_plain}</h1>" + chapter_content,
   "toc" => "<a href=\"#chap#{index.to_s}\">#{chapter_title_plain}</a><br>"}
end.select {|chapter| chapter}

@toc = "<h1>Table of Contents</h1>"
@book_body = ""

chapters.each do |chapter|
  @book_body << chapter["body"]
  @toc << chapter["toc"]
end

$stderr.puts "Writing Book..."

puts @toc
puts @book_body
