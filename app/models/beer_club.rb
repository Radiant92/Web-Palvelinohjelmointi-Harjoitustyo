class BeerClub < ApplicationRecord
  has_many :users
  has_many :memberships
  has_many :users, through: :memberships
end
