class WordController < ApplicationController
  def home
    @Words = Word.all
  end

  def update
    @word = Word.find(params[:id])
    @word.update_attribute(:zumi, true)
    redirect_to action: 'home'
  end
end
