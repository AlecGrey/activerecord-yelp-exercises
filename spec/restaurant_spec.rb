require_relative 'spec_helper'

describe 'Resaurant' do

  it "has a name" do
    restaurant = Restaurant.create(:name => "Alice's Restaurant")
    expect(restaurant.name).to eq ("Alice's Restaurant")
  end
  
  it "has associated dishes" do
    alices = Restaurant.create(:name => "Alice's Restaurant")
    
    pizza = Dish.new(:name => "pizza")
    pizza.restaurant = alices
    pizza.save
    
    pizza.reload
    expect(alices.dishes).to include(pizza)
    expect(pizza.restaurant).to eq(alices)
  end
  
  it "validates that name is present" do 
    expect(Restaurant.new(:name => nil).valid?).to be false
    expect(Restaurant.new(:name => "Alice's Restaurant").valid?).to be true
  end

  describe 'Restaurant.mcdonalds' do

    it 'finds the restaurant with the name "McDonalds"' do
      mcdonalds = Restaurant.create(name: "McDonalds")
      expect(Restaurant.mcdonalds.id).to eq(mcdonalds.id)
    end

  end

  describe 'Restaurant.tenth' do

    it 'finds the tenth restaurant' do
      for i in 1..10
        Restaurant.create(:name => "restaurant_#{i}")
      end

      expect(Restaurant.tenth.id).to eq(10)
    end
  end

  describe 'Restaurant.with_long_names' do

    it 'finds all the restaurants with names longer than 12 characters' do
      less_than_12 = Restaurant.create(:name => "123")
      exactly_12 = Restaurant.create(:name => "123456789012")
      greater_than_12_1 = Restaurant.create(:name => "really long name")
      greater_than_12_2 = Restaurant.create(:name => "really really long name")

      result = Restaurant.with_long_names
      expect(result).to include(greater_than_12_1)
      expect(result).to include(greater_than_12_2)
      expect(result).not_to include(exactly_12)
      expect(result).not_to include(less_than_12)
    end

  end

  describe 'Restaurant.focused' do

    it 'finds all the restaurants with fewer than 5 dishes' do
      greater_than_5 = Restaurant.create(:name => "less than 5 dishes")
      exactly_5   = Restaurant.create(:name => "exactly 5")
      expected1   = Restaurant.create(:name => "expected1")
      expected2   = Restaurant.create(:name => "expected2")

      for i in 1..14
        Dish.create(:name => "dish#{i}", :restaurant => greater_than_5)
      end

      for i in 15..19
        Dish.create(:name => "dish#{i}", :restaurant => exactly_5)
      end

      for i in 20..22
        Dish.create(:name => "dish#{i}", :restaurant => expected1)
      end

      for i in 23..26
        Dish.create(:name => "dish#{i}", :restaurant => expected2)
      end

      result = Restaurant.focused
      expect(result).to include(expected1)
      expect(result).to include(expected2)
      expect(result).not_to include(exactly_5)
      expect(result).not_to include(greater_than_5)
    end

  end

  describe 'Restaurant.large_menu' do

    it 'finds all the restaurants with more than 20 dishes' do
      fewer_than_20 = Restaurant.create(:name => "less than 20 dishes")
      exactly_20    = Restaurant.create(:name => "exactly 20")
      expected1     = Restaurant.create(:name => "expected1")
      expected2     = Restaurant.create(:name => "expected2")

      for i in 1..19
        Dish.create(:name => "dish#{i}", :restaurant => fewer_than_20)
      end

      for i in 20..39
        Dish.create(:name => "dish#{i}", :restaurant => exactly_20)
      end

      for i in 40..60
        Dish.create(:name => "dish#{i}", :restaurant => expected1)
      end

      for i in 61..81
        Dish.create(:name => "dish#{i}", :restaurant => expected2)
      end

      result = Restaurant.large_menu
      expect(result).to include(expected1)
      expect(result).to include(expected2)
      expect(result).not_to include(exactly_20)
      expect(result).not_to include(fewer_than_20)

    end

  end

  describe 'Restaurant.vegetarian' do

    it 'finds all the restaurants where all of the dishes are tagged vegetarian' do
      vegetarian = Tag.create(:name => "vegetarian")
      other = Tag.create(name: "other")

      no_vegetarian = Restaurant.create(:name => "no vegetarian")
      some_vegetarian = Restaurant.create(:name => "some vegetarian")
      all_vegetarian1 = Restaurant.create(:name => "all vegetarian 1")
      all_vegetarian2 = Restaurant.create(:name => "all vegetarian 2")

     Dish.create(:name => "not veggie1", :tags => [other], :restaurant => no_vegetarian)

     Dish.create(:name => "veggie1", :tags => [vegetarian], :restaurant => some_vegetarian)
     Dish.create(:name => "not veggie2", :restaurant => some_vegetarian)

     Dish.create(:name => "veggie2", :tags => [vegetarian], :restaurant => all_vegetarian1)

     Dish.create(:name => "veggie3", :tags => [vegetarian], :restaurant => all_vegetarian2)

     result = Restaurant.vegetarian
     expect(result).to include(all_vegetarian1)
     expect(result).to include(all_vegetarian2)
     expect(result).not_to include(no_vegetarian)
     expect(result).not_to include(some_vegetarian)
    end

  end
    
end
