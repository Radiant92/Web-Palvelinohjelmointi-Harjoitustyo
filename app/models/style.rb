class Style < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers
  include RatingAverage

  def self.top(amount)
    Style.all.sort_by{ |b| -(b.average_rating || 0) }.first(amount)
  end
end
