10.times {|i| Tag.create(name: "Tag" + i.to_s)}

20.times do |i|

    rest = Restaurant.create(name: "Restaurant" + i.to_s)

    10.times do |j|

        dish = Dish.create(name: "Dish" + j.to_s)

        3.times {dish.tags << Tag.all.sample}

        rest.dishes << dish

    end

end

