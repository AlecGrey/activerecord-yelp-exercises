class Restaurant < ActiveRecord::Base
  has_many :dishes

  validates :name, presence: true

  scope :with_dish_with_tag, -> (name) { joins(:dishes).merge(Dish.with_tag(name)).uniq }
  scope :with_vegetarian_dish, -> { with_dish_with_tag("vegetarian") }
  scope :with_dish_without_tag, -> (name) { joins(:dishes).merge(Dish.without_tag(name)).uniq }
  scope :with_non_vegetarian_dish, -> { with_dish_without_tag("vegetarian") }
  scope :without_dishes_without_tag, -> (name) { where.not(id: with_dish_without_tag(name)) }
  scope :vegetarian, -> { without_dishes_without_tag("vegetarian") }

  def self.mcdonalds
    Restaurant.find_by(:name => "McDonalds")
  end

  def self.tenth
    Restaurant.find(10)
  end

  def self.with_long_names
    where('LENGTH(name) > 12')
  end

  def self.focused
    joins(:dishes).having('COUNT(dishes.id) < 5').group(:restaurant_id)
  end

  def self.large_menu
    joins(:dishes).having('COUNT(dishes.id) > 20').group(:restaurant_id)
  end

  def self.name_like(name)
    where('name LIKE ?', "%#{name}%")
  end
end
