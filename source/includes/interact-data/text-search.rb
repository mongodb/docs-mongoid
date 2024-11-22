# start-text-index-model
class Dish
  include Mongoid::Document

  field :name, type: String
  field :description, type: String

  index description: 'text'
end
# end-text-index-model