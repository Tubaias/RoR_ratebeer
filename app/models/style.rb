class Style < ApplicationRecord
  include RatingAverage
  extend TopN

  has_many :beers
  has_many :ratings, through: :beers
end
