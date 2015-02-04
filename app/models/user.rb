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
    mode.beer.style
  end

  def get_styles
    return nil if (ratings.empty?)
    list = Array.new
    ratings.each{|x| list << (x.beer.style)}
  end

  def mode
    get_styles.group_by{|i| i}.max{|x,y| x[1].length <=> y[1].length}[0]
  end
end
