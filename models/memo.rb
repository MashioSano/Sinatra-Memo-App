# frozen_string_literal: true

require 'json'
require 'securerandom'
class Memo
  attr_accessor :title, :description, :id

  def initialize(text, id = SecureRandom.hex(8))
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
end
