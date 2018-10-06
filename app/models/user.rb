class User < ApplicationRecord
    include RatingAverage

    has_secure_password

    validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
    validates :password, length: { minimum: 4 }
    validate :password_contains_uppercase_char
    validate :password_contains_number

    has_many :ratings, dependent: :destroy
    has_many :beers, through: :ratings
    has_many :memberships, dependent: :destroy
    has_many :beer_clubs, through: :memberships

    def password_contains_uppercase_char
        return if password =~ /[A-Z]/

        errors.add(:password, "password must contain at least one upper case character")
    end

    def password_contains_number
        return if password =~ /[0-9]/

        errors.add(:password, "password must contain at least one number")
    end

    def average_of(ratings)
        ratings.sum(&:score).to_f / ratings.count
    end

    def favorite_beer
        return nil if ratings.empty?

        ratings.order(score: :desc).limit(1).first.beer
    end

    def favorite_style
        return nil if ratings.empty?

        style_ratings = ratings.group_by{ |r| r.beer.style }
        averages = style_ratings.map do |style, ratings|
          { style: style, score: average_of(ratings) }
        end

        averages.max_by{ |r| r[:score] }[:style]
    end

    def favorite_brewery
        return nil if ratings.empty?

        style_ratings = ratings.group_by{ |r| r.beer.brewery }
        averages = style_ratings.map do |brewery, ratings|
          { brewery: brewery, score: average_of(ratings) }
        end

        averages.max_by{ |r| r[:score] }[:brewery]
    end
end
