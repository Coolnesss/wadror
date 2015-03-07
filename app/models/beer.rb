class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings, dependent: :destroy
	has_many :raters, through: :ratings, source: :user
	belongs_to :style
	validates :style, presence: true
	validates :name, presence: true
	#validates :style, presence: true

  include RatingAverage

  def to_s
    self.name + ", panimo: " + brewery.name
  end

	def average
		return 0 if ratings.empty?
		ratings.map{ |r| r.score }.sum / ratings.count.to_f
	end

	def self.top(n)
		sorted_by_rating_in_desc_order = Beer.all.sort_by{ |b| -(b.average_rating||0) }
		sorted_by_rating_in_desc_order.take(n)
	end
end
