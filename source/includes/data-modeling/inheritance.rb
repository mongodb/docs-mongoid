# start-simple-inheritance
class Person
  include Mongoid::Document

  field :name, type: String
end

class Employee < Person
  field :company, type: String
  field :tenure, type: Integer

  scope :new_hire, ->{ where(:tenure.lt => 1) }
end

class Manager < Employee
end
# end-simple-inheritance