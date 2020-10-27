class DishTag < ActiveRecord::Base

    validates :tag, uniqueness: {scope: :dish}

    belongs_to :dish
    belongs_to :tag

end
