class User < ActiveRecord::Base
  acts_as_authentic

  validates_presence_of :first_name
  validates_presence_of :email

  has_many :histories

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.password_reset_instructions(self).deliver_now
  end

  def location?
    !country.nil? && !city.nil?
  end
end
