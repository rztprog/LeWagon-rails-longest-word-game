require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ("a".."z").to_a.shuffle.first(10)
  end
  
  def score
    @word = params[:word].downcase.split("")
    letters = params[:letters].downcase.split("")
    mod_letters = params[:letters].downcase.split("")
    @message = ""
    result = ""

    @word.each do |letter|
      if mod_letters.index(letter)
        result = result + letter
        mod_letters.slice!(mod_letters.index(letter))
      else
        result = nil
        break if result.nil?
      end
    end

    @word = @word.join("").upcase

    if result.nil?
      @message = "Sorry but #{@word} can't be built out of #{letters.join(", ").upcase}"
    elsif isEnglish(@word)
      @message = "Congratulation! #{@word} is a valid English world!"
    else
      @message = "Sorry but #{@word} does not seem to be a valid English word..."
    end
  end

  private

  def isEnglish(word)
    urlpath = "https://wagon-dictionary.herokuapp.com/#{word}"
    result = JSON.parse(URI.open(urlpath).read)
    return result["found"]
  end
end
