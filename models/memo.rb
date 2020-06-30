# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'pg'
require 'sinatra/reloader'
require 'dotenv'

Dotenv.load

class Memo
  attr_accessor :title, :description, :id

  def initialize(text, id = nil)
    @title = split_text(text, title)
    @description = split_text(text, description)
    @id = id
  end

  def split_text(text, option)
    description_list = text.split("\n")
    if option == title
      description_list[0]
    else
      description_list[1..-1].join("\n")
    end
  end

  def self.execute_sql(sql, params)
    connection = PG.connect(host: ENV['HOST'], user: ENV['USER'], password: ENV['PASSWORD'], dbname: ENV['DBNAME'], port: ENV['PORT'])
    connection.exec_params(sql, params)
  ensure
    connection.finish
  end

  def self.all
    result = execute_sql("SELECT * FROM #{ENV['TABLENAME']} ORDER BY ID DESC", nil)
    result.map do |r|
      Memo.new([r['title'], r['description']].join("\n"), r['id'])
    end
  end

  def self.find(id)
    result = execute_sql("SELECT * FROM #{ENV['TABLENAME']} WHERE id = $1", [id])
    text = [result[0]['title'], result[0]['description']].join("\n")
    Memo.new(text, result[0]['id'])
  end

  def self.create(text)
    memo = Memo.new(text)
    sql = "INSERT INTO #{ENV['TABLENAME']} (title, description) VALUES($1, $2)"
    params = [memo.title, memo.description]
    execute_sql(sql, params)
  end

  def self.delete(id)
    sql = "DELETE FROM #{ENV['TABLENAME']} WHERE id = $1"
    params = [id]
    execute_sql(sql, params)
  end

  def self.update(text, id)
    edited_memo = Memo.new(text)
    sql = "UPDATE #{ENV['TABLENAME']} SET title = $1, description = $2 WHERE id = $3"
    params = [edited_memo.title, edited_memo.description, id]
    execute_sql(sql, params)
  end
end
