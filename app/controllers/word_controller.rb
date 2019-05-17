class WordController < ApplicationController
  def home
    puts '** home ***'
    @words = Word.all
  end

  def new
    puts '** new ***'
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)
    if @word.save
      flash[:success] = "Add keyWord!"
      redirect_to @word
    else
      render 'new'
    end
  end

  def update
    @word = Word.find(params[:id])
    @word.update_attribute(:zumi, true)
    redirect_to action: 'home'
  end

  def show
    @word = Word.find(params[:id])
  end

  private
  def word_params
    params.require(:word).permit(:key)
  end
end
