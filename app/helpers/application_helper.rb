module ApplicationHelper

  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "PG Training"
    if page_title.empty?
      base_title
    elsif @micropost.present?
      @micropost.title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
