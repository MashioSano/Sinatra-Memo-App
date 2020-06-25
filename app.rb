# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './models/memo.rb'

enable :method_override

get '/memos' do
  @memos = read_json_file
  erb :index
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  memos = read_json_file
  @memo = memos[params[:id]]
  erb :show
end

post '/memos' do
  memo = Memo.new(params[:text])
  redirect to('/memos') if memo.title.nil?
  memos = read_json_file
  memos[memo.id] = { 'title' => memo.title, 'description' => memo.description }
  write_json_file(memos)
  redirect to("/memos/#{memo.id}")
end

get '/memos/:id/edit' do
  memos = read_json_file
  @memo = memos[params[:id]]
  erb :edit
end

patch '/memos/:id' do
  memo = Memo.new(params[:text], params[:id])
  redirect to('/memos') if memo.title.nil?
  memos = read_json_file
  memos[memo.id] = { 'title' => memo.title, 'description' => memo.description }
  write_json_file(memos)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  memos = read_json_file
  memos.delete(params[:id])
  write_json_file(memos)
  redirect to('/memos')
end

def read_json_file
  File.open('memos.json') do |file|
    JSON.load(file)
  end
end

def write_json_file(memos)
  File.open('memos.json', 'w') do |file|
    JSON.dump(memos, file)
  end
end


helpers do
  def link_to(txt, url)
    %(<a href="#{url}">#{txt}</a>)
  end
end
