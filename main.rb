require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'github/markdown'
require 'pry'

configure { set :server, :puma }

class Article
  attr_reader :title, :content, :category

  def initialize(title, content, category)
    @title    = title
    @content  = content
    @category = category
  end
end

class Blog
  attr_reader :articles
  def initialize
    @articles = []
    load_articles
  end

  def add_article(article)
    @articles << article
  end

  def by_category(category)
    @articles.select{|article| article.category == category}
  end

  def by_title(title)
    @articles.select{|article| article.title == title}
  end

  def load_articles
    categories = Dir.entries("articles").select{|category| category != "." && category != ".."}
    categories.each do |category|
      articles = Dir.entries("articles/#{category}").select{|article| article != "." && article != ".."}
      articles.each do |article|
        content = File.read("articles/#{category}/#{article}")
        content_html = GitHub::Markdown.to_html(content, :gfm)
        add_article(Article.new(article, content_html , category))
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
  @article = blog.by_title(params[:title]).first
  erb :article
end
