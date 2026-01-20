require "open-uri"
require "json"

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split

    unless @word.chars.all? { |char| @letters.include?(char) }
      @score = "Sorry, but #{@word} can’t be built out of the original grid"
      return
    end

    url = "https://dictionary.lewagon.com/#{@word}"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["found"]
      @score = "Congratulations! #{@word} is a valid English word!"
    else
      @score = "Sorry but #{@word} does not seem to be a valid English word..."
    end
    
  end

end
