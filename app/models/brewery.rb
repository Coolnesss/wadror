class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validate :not_in_future
  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
    greater_than_or_equal_to: 1042 }

    scope :active, -> { where active:true }
    scope :retired, -> { where active:[nil,false] }

  include RatingAverage

  def self.top(n)
    sorted_by_rating_in_desc_order = Brewery.all.sort_by{ |b| -(b.average_rating||0) }
    sorted_by_rating_in_desc_order.take(n)
  end


  def not_in_future
    if year.present? && year > Time.now.year
      errors.add(:year, "can't be in the future")
    end
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = Time.now.year
    puts "changed year to #{year}"
  end

  def to_s
    self.name
  end
end
