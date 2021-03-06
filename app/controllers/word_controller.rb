require "word.rb"

class WordController < ApplicationController
  # require "thor"
  # require "pry"

  def home
    puts '** home ***'
    @q = Word.ransack(params[:q])
    @words = @q.result(distinct: true).order(check: "ASC").order(created_at: "DESC")

    if Rails.cache.exist?('cnt')
      Rails.cache.delete('cnt')
      Rails.cache.write('cnt', '1')
    end

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
    study_get
  end

  def study_rails
    puts 'search_rails --------------'
    Rails.cache.write('search', '%Rails%')
    study_get
  end
  def study_docker
    puts 'search_docker --------------'
    Rails.cache.write('search', '%Docker%')
    study_get
  end
  def study_get
    @search = Rails.cache.read('search')
    # @words = Word.where('key LIKE ?', "%Rails%").order(id: "ASC").first
    if @search != ''
      id = Word.where('key LIKE ?', @search).pluck(:id)
    else
      id = Word.pluck(:id)
    end
    # 任意のID取得
    idx = id.sample
    @words = Word.find_by(id: idx)
    #総数
    @cnt_all = id.length
    #インデックス（表示用に+1）
    @cnt = id.find_index(idx) + 1

    Rails.cache.write('cnt_all', @cnt_all.to_s)
    Rails.cache.write('cnt', @cnt.to_s)
  end

  def search
    puts 'search --------------'
    # @q = Word.ransack(params[:q])
    # @q = Word.ransack(params[:q]).ransack(s: "check ASC")

    # ラジオボタンの選択値を検索条件にする（テキストボックスは削除）
    if params[:page] == 'all'
      # allの場合は検索条件なし
      params[:q] = ''
      Rails.cache.write('search', '')
    else
      params[:q] = {key_cont: params[:page] }
      Rails.cache.write('search', '%'+params[:page]+'%')
    end

    @q = Word.ransack(params[:q])
    @words = @q.result(distinct: true)
    @words = @words.order(check: "ASC", id: "ASC")

    render 'home'
  end

  def study_next
    @cnt_all = Rails.cache.read('cnt_all').to_i
    @cnt = Rails.cache.read('cnt').to_i + 1
    Rails.cache.write('cnt', @cnt.to_s)

    # @words = Word.next(params[:id])
    # @words = Word.where("id > ?", params[:id]).order("id ASC").first

    @search = Rails.cache.read('search')
    @words = Word.where("(key LIKE ?) and (id > ?)",@search , params[:id]).order(id: "ASC").first
    if @words.nil?
      #TODO フラッシュほしい
      redirect_to action: 'home'
    else
      render 'study_rails'
    end
  end
  def study_back

    @search = Rails.cache.read('search')

    @cnt_all = Word.where('key LIKE ?', @search).count
    @cnt = Rails.cache.read('cnt').to_i - 1
    Rails.cache.write('cnt', @cnt.to_s)
    @words = Word.where("(key LIKE ?) and (id < ?)",@search , params[:id]).order(id: "DESC").first
    if @words.nil?
      #TODO フラッシュほしい
      redirect_to action: 'home'
    else
      render 'study_rails'
    end
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
