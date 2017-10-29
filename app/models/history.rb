class History < ActiveRecord::Base
  validates :search_param, presence: true
  validates :city, presence: true
  validates :country, presence: true

  validates :weather_type, presence: true
  validates :tempature, presence: true

  belongs_to :user
end
