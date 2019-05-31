class Word < ApplicationRecord

  def previous(id)
    self.where("id < ?", self.id).order("id DESC").first
  end

  def next(id)
    self.where("id > ?", self.id).order("id ASC").first
  end

  #うまくいかない。。
  # scope : next, ->(id) { where("id > ?", id) }

  #うまくいかない。。
  # def next(id)
    # scope : track_count, ->(count) { where("track_count < ?", count) }
    # self.where("id > ?", id).order("id ASC").first
  # end


end
