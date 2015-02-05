class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username,
                    uniqueness: true,
                    length: { in: 5..20 }
  validates :password,  length: { minimum: 4 }
  validates_format_of :password, :with => /(?=.*\d)(?=.*([A-Z]))/

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favourite_style
    return nil if (ratings.empty?)
    lista = beers.all.map(&:style)
    lista.max_by{|x| get_average_for_style x}
  end

  def get_average_for_style style
    return nil if (ratings.empty?)
    ratings_for_style = ratings.select{|x| x.beer.style == style}
    ratings_for_style.map(&:score).inject{ |sum, el| sum + el }.to_f / ratings_for_style.size
  end
end
