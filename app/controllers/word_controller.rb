require "word.rb"

class WordController < ApplicationController
  # require "thor"
  # require "pry"

  def home
    puts '** home ***'
    @q = Word.ransack(params[:q])
    @words = @q.result(distinct: true).order(check: "ASC").order(created_at: "DESC")

    # @words = Word.all
    # @words = Word.all.order(check: "ASC").order(created_at: "DESC")


    # respond_to do |format|
    #   format.html do
    #       #html用の処理を書く
    #   end
    #   format.csv do
    #       #csv用の処理を書く
    #   endw
    # end

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

  def study
    puts 'search --------------'
    # #検索結果が得られない。。（保留中 2019/5/29
    # @q = Word.ransack(params[:q])
    # @words = @q.result(distinct: true)
    @words = Word.limit(10).order(check: "ASC")
    @keys = @words.pluck(:key)
    puts @keys.length
    puts @keys

    @words_json = @keys.to_json.html_safe
    puts @words_json
  end

  def study_rails
    puts 'search_rails --------------'
    @words = Word.where('key LIKE ?', "%Rails%").order(check: "ASC", id: "ASC").first

  end

  def search
    puts 'search --------------'
    # @q = Word.ransack(params[:q])
    # @q = Word.ransack(params[:q]).ransack(s: "check ASC")
    @q = Word.ransack(params[:q])
    @words = @q.result(distinct: true)
    @words = @words.order(check: "ASC", id: "ASC")
    render 'home'
  end


  def study_next
    # @words = Word.next(params[:id])
    # @words = Word.where("id > ?", params[:id]).order("id ASC").first
    @words = Word.where("(key LIKE ?) and (id > ?)","%Rails%" , params[:id]).order(check: "ASC").first
    render 'study_rails'
  end
  def study_upd_add
    upd_add
    study_next
  end
  def study_upd_mns
    upd_mns
    study_next
  end


  def upd_add
    @word = Word.find(params[:id])
    @word[:check] = @word[:check].to_i + 1
    @word.save

    #NGエラー
    # Word.where(params[:id]).update("check=check+1")


    # @word = Word.find(params[:id])
    # @word.update_attribute(:zumi, true)


    # もともと（これだと一番上に戻ってしまう）
    # redirect_to action: 'home'

    # NG なんか違う。。【リンクみたいにしたいけど】
    # redirect_to 'http://localhost:3000#word/899/upd_add'

    # まだできていない
    # respond_to do |format|
    #  # format.html { redirect_to action: 'home' }
    #  format.html { redirect_to @word }
    #  format.js
    # end
  end

  def upd_mns

    @word = Word.find(params[:id])
    @word[:check] = @word[:check].to_i - 1
    @word.save


    # @word = Word.find(params[:id])
    # @word.update_attribute(:zumi, false)
    # # redirect_to action: 'home'
    # respond_to do |format|
    #  format.html { redirect_to @word }
    #  format.js
    # end
  end

  def show
    @word = Word.find(params[:id])
    noko
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

  def  noko
     require 'open-uri'
     require 'nokogiri'
     require 'cgi'

     # charset = nil
     # html = open("https://www.google.com/search?q=#{@word.key}") do |f|
     #    charset = f.charset
     #    f.read
     # end

     # doc = Nokogiri::HTML.parse(html, nil, charset)
     @tmp1 = []
     @tmp2 = []
     @tmp3 = []
     @tmp4 = []
     @tmp5 = []

     #
     # @tmp5 =  html.scan(%r{<h3 class="LC20lb">(.+?)</h3>})
     #
     charset = nil
     @url = URI.encode "https://www.google.com/search?hl=jp&gl=JP&q=#{@word.key}"
     html = open(@url) do |f|
        charset = f.charset
        f.read
     end
     doc = Nokogiri::HTML.parse(html, nil, charset)
     # doc.xpath('//h3[@class="LC20lb"]').each do |f|
     #   puts '---------1'
     #   puts f.text
     # end


     puts 'vvvvvvvvvvvvvvvvvv'
     doc.xpath('//h3[@class="r"]').each do |f|
       puts f
       @tmp1.push(f.text)
       url = CGI.unescape(CGI.unescapeHTML(f.xpath('a/@href').text))
       if !url.empty? then
         @tmp2.push(url.split('&sa=U&ved=').first.sub('/url?q=', ''))
       end
     end
     puts '^^^^^^^^^^^^^^^^^^^'

     doc = Nokogiri::HTML.parse(html, nil, charset)
     # @tmp3 = doc.css('h3')      #Google（タイトル）
     @tmp3 = doc.css('span.st') #Google（ユニペット）
     for num in 0..@tmp3.length-1
       @tmp4.push(@tmp3[num].content)
     end


     # doc.xpath('//h3[@class = "r"]/a[@class = "l"]').each do |f|
     #   puts '---------2'
     #   puts f.text
     #   @tmp2.push(f.text)
     # end
     # doc.each do |f|
     #   puts '---------3'
     #   puts f.text
     # end

  end


end
