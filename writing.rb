require 'nokogiri'
require 'open-uri'
require 'uri'
require 'parallel'

class Writing
  attr_reader :title, :contents

  def initialize link
    @link = link

    build_writing
  end

  def build_writing
    url = $BASE_URL + @link.at_css('a')['href'].gsub(/^\//, '')
    url = $BASE_URL +
          Nokogiri::HTML(open(url)).at_css('dt//a')['href'].gsub(/^\//, '')
    puts "fetching at #{url}"
    writing_page = Nokogiri::HTML(open(url))
    @title = writing_page.at_css('.title').text
    @contents = writing_page.at_css('body//.t_txt')
    @year = @contents.at_css('.t_year//p').text.gsub(/[^\d]/, "")
    @contents.css('script, .t_end, .t_year').remove
    @contents = @contents.to_s.gsub(/<div.*?>/, '').gsub(/h2/, 'h3')
  end

  def full_title
    if !@year.empty?
      @title + " (#{@year})"
    else
      @title
    end
  end
end
