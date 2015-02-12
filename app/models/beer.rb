class Beer < ActiveRecord::Base
	belongs_to :brewery
	has_many :ratings, dependent: :destroy
	has_many :raters, through: :ratings, source: :user
	belongs_to :style

	validates :name, presence: true
	#validates :style, presence: true

  include RatingAverage

  def to_s
    self.name + ", panimo: " + brewery.name
  end

	def average
		ratings.map{ |r| r.score }.sum / ratings.count.to_f
	end
end
