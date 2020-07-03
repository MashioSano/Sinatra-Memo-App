# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require_relative 'models/memo.rb'

get '/memos/new' do
  erb :new
end

get '/memos' do
  @memos = Memo.all
  erb :index
end

get '/memos/:id' do
  @memo = Memo.find(params[:id])
  erb :show
end

post '/memos' do
  redirect to('/memos') if params[:text] == ''
  Memo.create(title: extract_title(params[:text]), description: extract_description(params[:text]))
  redirect to('/memos')
end

get '/memos/:id/edit' do
  @memo = Memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  redirect to('/memos') if params[:text] == ''
  Memo.find(params[:id]).update(title: extract_title(params[:text]), description: extract_description(params[:text]))
  redirect to('/memos')
end

delete '/memos/:id' do
  Memo.find(params[:id]).delete
  redirect to('/memos')
end

def extract_title(params)
  params.split("\n")[0].strip
end

def extract_description(params)
  params.split("\n")[1..-1].join("\n").strip
end

helpers do
  def link_to(txt, url)
    %(<a href="#{url}">#{txt}</a>)
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
