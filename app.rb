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
  Memo.create(params[:text])
  redirect to('/memos')
end

get '/memos/:id/edit' do
  @memo = Memo.find(params[:id])
  erb :edit
end

patch '/memos/:id' do
  Memo.update(params[:text], params[:id])
  redirect to('/memos')
end

delete '/memos/:id' do
  Memo.delete(params[:id])
  redirect to('/memos')
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
