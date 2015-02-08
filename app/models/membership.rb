class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates :user, presence: true

  #validate :no_duplicate_users

  #def no_duplicate_users
  #  if not beer_club.users.find_by(username: user.username).nil?
  #    errors.add(:user, "is already in club!")
  #  end
  #end

end
