class Beer < ApplicationRecord
  include RatingAverage
  belongs_to :brewery, touch: true
  belongs_to :style, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user
  validates :name, presence: true
  validates :style, presence: true

  def to_s
    "#{name} #{brewery.name}"
  end

  def self.top(amount)
    Beer.all.sort_by{ |b| -(b.average_rating || 0) }.first(amount)
  end
end
