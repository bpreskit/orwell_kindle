require 'nokogiri'
require 'open-uri'
require 'uri'
require 'parallel'
require './writing'

$BASE_URL = 'http://orwell.ru/'

class Genre
  attr_accessor :name, :page
  attr_reader :toc_entry, :genre_text
  
  def initialize name, page
    @name = name
    @page = page

    build_genre
  end

  def build_genre
    @toc_entry = toc_init
    @genre_text = genre_beginning

    genre_links = @page.css('.s_list dd')
    writings = Parallel.map_with_index(genre_links, :in_threads => 4) do |link, ind|
      add_writing link, ind
    end
    finish_genre
  end

  def toc_init
      "<a href=\"#genre_#{@name.downcase}\">" +
      @name +
      "</a><br>\n"
  end

  def genre_beginning
    "<h1 id=\"genre_#{@name.downcase}\">" +
      @name + "</h1>"
  end

  def add_writing link, ind
    puts link.at_css('a')['href']
    writing = Writing.new link
    puts "Fetched #{writing.title}\n"
    @toc_entry += "<a href=\"##{@name.downcase}_#{ind}\">" +
                  writing.full_title + "</a><br>\n"

    @genre_text += "" +
                   "<h2 " + 
                   "id=\"#{@name.downcase}_#{ind}\">" +
                   writing.full_title + "</h2>\n" +
                   writing.contents + "\n"
  end

  def finish_genre
    
  end
end
