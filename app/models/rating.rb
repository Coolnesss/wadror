class Rating < ActiveRecord::Base
  belongs_to :beer
  belongs_to :user, dependent: :destroy

  validates :score, numericality: { greater_than_or_equal_to: 1,
    less_than_or_equal_to: 50,
    only_integer: true }

  def to_s
    "#{self.beer.name}" + " " + "#{self.score}"
  end

  def self.most_recent(limit)
    Rating.all.order("created_at desc").limit(limit)
  end

end
