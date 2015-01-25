class BeerClub < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  #validates :founded #todo numeric
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships

  def to_s
    self.name
  end
end
