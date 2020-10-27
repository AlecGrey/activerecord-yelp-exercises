class Restaurant < ActiveRecord::Base

    validates :name, presence: true
    
    has_many :dishes

    def self.mcdonalds
        self.find_by(name: "McDonalds")
    end

    def self.tenth
        self.find(9)
    end

    def self.with_long_names
        self.all.select {|rest| rest.name.length > 12}
    end

    def self.max_dishes
        self.all.max_by {|rest| rest.dishes.size}
    end

    def self.focused
        self.all select {|rest| rest.dishes < 5}
    end

    def self.large_menu
        self.all.select {|rest| rest.dishes.size > 20}
    end

    def self.vegetarian
        self.all.select do |rest| 
            rest.dishes.any? {|dish| dish.tags.include?(Tag.find_by(name: "Vegetarian"))}
        end
    end

    def self.name_like(name)
        self.all.select {|rest| rest.name.include?(name)}
    end

    def self.name_not_like(name)
        self.all.select {|rest| rest.name.!include?(name)}
    end

end