class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username,
                    uniqueness: true,
                    length: { in: 6..20 }
  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
end
