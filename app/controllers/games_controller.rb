require "open-uri"
require "json"

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split

    # Initialize total_score in session
    session[:total_score] ||= 0

    unless @word.chars.all? { |char| @letters.include?(char) }
      @score = "Sorry, but #{@word} can’t be built out of the original grid"
      return
    end

    url = "https://dictionary.lewagon.com/#{@word}"
    response = URI.open(url).read
    result = JSON.parse(response)

    if result["found"]
      # Calculate points = word length
      points = @word.length
      session[:total_score] += points  # add to session
      @score = "Congratulations! #{@word} is a valid English word! You get +#{points} points. Total score: #{session[:total_score]}"
    else
      @score = "Sorry but #{@word} does not seem to be a valid English word..."
    end

  end

  def reset_score
    session[:total_score] = 0
    redirect_to new_path
  end

end
