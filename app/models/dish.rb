class Dish < ActiveRecord::Base

    validates :name, presence: true
    validates :restaurant, presence: true

    belongs_to :restaurant
    has_many :dish_tags
    has_many :tags, through: :dish_tags 

end