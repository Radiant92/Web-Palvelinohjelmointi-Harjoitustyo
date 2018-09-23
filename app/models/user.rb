class User < ApplicationRecord
  include RatingAverage
  has_secure_password
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
  has_many :beers, through: :ratings
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{3,}\z/ }
  def average
    return 0 if ratings.empty?

    "%.4g" % (ratings.map(&:score).sum / ratings.count.to_f)
  end
end
