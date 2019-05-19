class WordController < ApplicationController
  # require "thor"
  # require "pry"

  def home
    puts '** home ***'
    @words = Word.all
  end

  def new
    puts '** new ***'
    @word = Word.new
  end

  def create
    puts '***** create *****'
    #一括登録（改行が区切り）
    tmp = params[:word][:key].split("\r\n")
    tmp.each do |f|
      @words = Word.new(key: f)
      @words.save
    end
    redirect_to action: 'home'
  end

  def upd_add
    @word = Word.find(params[:id])
    @word.update_attribute(:zumi, true)
    redirect_to action: 'home'
  end

  def upd_mns
    @word = Word.find(params[:id])
    @word.update_attribute(:zumi, false)
    redirect_to action: 'home'
  end

  def show
    @word = Word.find(params[:id])
  end

  def destroy
    @word = Word.find(params[:id])
    @word.destroy
    redirect_to action: 'home'
  end

  def del_all
    Word.destroy_all
    redirect_to action: 'home'
  end

  private
  def word_params
    params.require(:word).permit(:key)
  end
end
