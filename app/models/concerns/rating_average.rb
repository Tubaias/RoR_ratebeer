module RatingAverage
    extend ActiveSupport::Concern

    def average_rating
        scores = ratings.map { |rating| rating.score }
        sum = scores.reduce { |a, b| a + b }
        sum / ratings.count
    end
end
