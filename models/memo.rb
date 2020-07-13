# frozen_string_literal: true

require 'json'
require 'securerandom'
require 'pg'
require 'sinatra/reloader'
require 'dotenv'

Dotenv.load

class Memo
  attr_accessor :title, :description, :id

  @@connection = PG.connect(host: ENV['HOST'], user: ENV['USER'], password: ENV['PASSWORD'], dbname: ENV['DBNAME'], port: ENV['PORT'])

  def initialize(title:, description:, id:)
    @title = title
    @description = description
    @id = id
  end

  def self.all
    result = @@connection.exec_params('SELECT * FROM memo ORDER BY ID DESC', nil)
    result.map do |r|
      Memo.new(title: r['title'], description: r['description'], id: r['id'])
    end
  end

  def self.find(id)
    result = @@connection.exec_params('SELECT * FROM memo WHERE id = $1', [id])
    Memo.new(title: result[0]['title'], description: result[0]['description'], id: result[0]['id'])
  end

  def self.create(title:, description:)
    sql = 'INSERT INTO memo (title, description) VALUES($1, $2)'
    params = [title, description]
    @@connection.exec_params(sql, params)
  end

  def delete
    sql = "DELETE FROM memo WHERE id = #{id}"
    @@connection.exec_params(sql, nil)
  end

  def update(title:, description:)
    sql = "UPDATE memo SET title = $1, description = $2 WHERE id = #{id}"
    params = [title, description]
    @@connection.exec_params(sql, params)
  end
end
