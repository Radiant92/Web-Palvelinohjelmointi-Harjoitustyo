class User < ApplicationRecord
  include RatingAverage
  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :beers, through: :ratings
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{3,}\z/ }
  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    biggest = -1
    winner = nil
    lista = ratings.group_by { |rating| rating.beer.style }
    lista.each do |key, ratings|
      value = (ratings.sum(&:score) / ratings.count)
      if biggest < value
        biggest = value
        winner = key
      end
    end
    winner.name
  end

  def favorite_brewery
    return nil if ratings.empty?

    biggest = -1
    winner = nil
    lista = ratings.group_by { |rating| rating.beer.brewery }
    lista.each do |key, ratings|
      value = (ratings.sum(&:score) / ratings.count)
      if biggest < value
        biggest = value
        winner = key
      end
    end
    winner.name
  end
end
