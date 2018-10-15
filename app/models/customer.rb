class Customer < ActiveRecord::Base
  has_many :orders
  has_many :restaurants, through: :orders
  has_many :reviews

  validates :name, :lat, :lon, presence: true
  validates :lat, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :lon, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
end
