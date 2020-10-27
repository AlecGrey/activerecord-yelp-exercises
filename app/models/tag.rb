class Tag < ActiveRecord::Base

    validates :name, length: {minimum: 3}, if: :two_or_less_words?

    has_many :dish_tags
    has_many :dishes, through: :dish_tags


  def two_or_less_words?
    words = self.name.split(" ").length
    words <= 2
  end

end
