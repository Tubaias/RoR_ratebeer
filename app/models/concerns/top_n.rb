module TopN
  extend ActiveSupport::Concern

  def top(number)
    sorted_by_rating_in_desc_order = all.sort_by{ |b| -(b.average_rating || 0) }
    sorted_by_rating_in_desc_order[0..(number - 1)]
  end
end
