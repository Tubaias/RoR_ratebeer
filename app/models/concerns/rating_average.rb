module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    scores = ratings.map { |rating| rating.score }
    sum = scores.reduce { |a, b| a + b }
    if sum
      sum / ratings.count.to_f
    else
      0
    end
  end
end
