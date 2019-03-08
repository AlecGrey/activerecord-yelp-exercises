require_relative 'spec_helper'

describe 'Review' do
  describe 'model' do
    it 'extends ActiveRecord::Base' do
      expect(Review).to be < ActiveRecord::Base
    end
    it 'has content' do
      expect(Review.column_names).to include('content')
    end
    it 'has a rating' do
      expect(Review.column_names).to include('rating')
    end
    it 'has a date' do
      expect(Review.column_names).to include('date')
    end
    it 'belongs to a Customer' do
      expect(Review.reflect_on_association(:customer).macro).to eq(:belongs_to)
    end
    it 'belongs to a Restaurant' do
      expect(Review.reflect_on_association(:restaurant).macro).to eq(:belongs_to)
    end
  end
  describe 'validations' do
    let(:r) {Restaurant.find_or_create_by(name: "Alice's Restaurant")}
    let(:d) {Dish.create(name: "pizza", restaurant: r)}
    let(:c) {Customer.find_or_create_by(name: "name", lat: 0, lon: 0)}
    let(:c1) {Customer.find_or_create_by(name: "different_name", lat: 0, lon: 0)}
    let!(:o) {o = Order.create(customer: c, restaurant: r, dishes: [d]); c.reload; o}

    it 'validates that customer is present' do
      expect(Review.new(customer: nil, restaurant: r, content: "Some Content", rating: 1).valid?).to be false
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 1).valid?).to be true
    end
    it 'validates that customer has orders from the same restaurant' do
      expect(Review.new(customer: c1, restaurant: r, content: "Some Content", rating: 1).valid?).to be false
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 1).valid?).to be true
    end
    it 'validates that restaurant is present' do
      expect(Review.new(customer: c, restaurant: nil, content: "Some Content", rating: 1).valid?).to be false
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 1).valid?).to be true
    end
    it 'validates that content is longer than 10 characters' do
      expect(Review.new(customer: c, restaurant: r, content: "Some Cont", rating: 1).valid?).to be false
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 1).valid?).to be true
    end
    it 'validates that rating exists' do
      expect(Review.new(customer: c, restaurant: r, content: "Some Content").valid?).to be false
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 1).valid?).to be true
    end
    it 'validates that rating is 1, 2, 3, 4, or 5' do
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 0).valid?).to be false
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 6).valid?).to be false
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 1).valid?).to be true
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 2).valid?).to be true
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 3).valid?).to be true
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 4).valid?).to be true
      expect(Review.new(customer: c, restaurant: r, content: "Some Content", rating: 4).valid?).to be true
    end
  end
end
