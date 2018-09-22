class User < ApplicationRecord
    include RatingAverage

    has_secure_password

    validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
    validates :password, length: {minimum: 4}
    validate :password_contains_uppercase_char
    validate :password_contains_number

    has_many :ratings, dependent: :destroy
    has_many :beers, through: :ratings
    has_many :memberships, dependent: :destroy
    has_many :beer_clubs, through: :memberships

    def password_contains_uppercase_char
        if not password =~ /[A-Z]/
            errors.add(:password, "password must contain at least one upper case character")
        end
    end

    def password_contains_number
        if not password =~ /[0-9]/
            errors.add(:password, "password must contain at least one number")
        end
    end
end
