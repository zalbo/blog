require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'github/markdown'

configure { set :server, :puma }

class Article
  attr_reader :title, :content, :category

  def initialize(title, content, category)
    @title    = title
    @content  = content
    @category = category
  end
end

def load_articles
  article = File.read("articles/multirotore.md")
  GitHub::Markdown.to_html(article, :gfm)
end

class Blog
  attr_reader :articles
  def initialize
    @articles = []
    add_article(Article.new("nuovo_drone", load_articles , "3d"))
    add_article(Article.new("clone_orologio", "bla bla bla", "design"))
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




