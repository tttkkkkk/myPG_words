class StaticPagesController < ApplicationController

  def home
    # @micropost  = current_user.microposts.build
    # @feed_items = current_user.feed.paginate(page: params[:page])
    puts "** home **"
    @microposts = Micropost.all
    if @microposts.any?
      puts "** ok home **"
    elsif
      puts  @microposts.count
      puts "** ng  home **"
    end

  end

  def help
    puts "** help **"
  end

  def RoR
    puts "** RoR **"
  end

  #TODO カテゴリID の固定値はNG...（動的にしたい）
  def js
    search(1)
  end
  def rails
    search(2)
  end
  def jquery
    search(3)
  end
  def sitemap
    search()
  end

  private
   def search(id=0)
     if id == 0
       # @microposts = Micropost.all
       @q = Micropost.ransack(params[:q])
       @microposts = @q.result(distinct: true).page(params[:page])
     else
       @microposts = Micropost.where(category_id: id)
     end
   end


end
