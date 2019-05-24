require 'csv'

CSV.generate do |csv|
  # column_names = %w(word)
  # csv << column_names
  @words.each do |f|
    column_values = [
      f.key
    ]
    csv << column_values
  end
end
