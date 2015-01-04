require 'rubygems'
require 'bundler/setup'

require 'sinatra'
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
    add_article(Article.new("nuovo drone", "bla bla bla", "3d"))
    add_article(Article.new("clone orologio", "bla bla bla", "design"))
  end

  def add_article(article)
    @articles << article
  end

  def by_category(category)
    @articles.select{|article| article.category == category}
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


