require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'github/markdown'
require 'pry'

configure { set :server, :puma }

class Article
  attr_reader :title, :content, :category, :better_title

  def initialize(title, content, category)
    @title    = title.gsub(".md", "")
    @content  = content
    @category = category
    @better_title = title.gsub(".md", "").gsub("-"," ").upcase
  end
end

class Blog
  attr_reader :articles
  def initialize
    @articles = []
    load_articles
  end

  def by_category(category)
    @articles.select{|article| article.category == category}
  end

  def find_by_title(title)
    @articles.select{|article| article.title == title}.first
  end

  def load_articles
    categories = Dir.entries("articles").select{|category| category != "." && category != ".."}
    categories.each do |category|
      articles = Dir.entries("articles/#{category}").select{|article| article != "." && article != ".."}
      articles.each do |article|
        content = File.read("articles/#{category}/#{article}")
        content_html = GitHub::Markdown.to_html(content, :gfm)
        @articles << Article.new(article, content_html , category)
      end
    end
  end
end



blog = Blog.new

get '/' do
  @articles = blog.articles
  erb :index
end

get '/:category' do
  @articles = blog.by_category(params[:category])
  erb :index
end

get '/article/:title' do
  @article = blog.find_by_title(params[:title])
  erb :article
end
