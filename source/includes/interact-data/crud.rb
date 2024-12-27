# start create! example
Person.create!(
  first_name: "Heinrich",
  last_name: "Heine"
)

Person.create!([
  { first_name: "Heinrich", last_name: "Heine" },
  { first_name: "Willy", last_name: "Brandt" }
])

Person.create!(first_name: "Heinrich") do |doc|
  doc.last_name = "Heine"
end
# end create! example

# start create example
Person.create(
  first_name: "Heinrich",
  last_name: "Heine"
)

class Post
  include Mongoid::Document
  validates_uniqueness_of :title
end

posts = Post.create([{title: "test"}, {title: "test"}])

posts.map { |post| post.persisted? } # => [true, false]
# end create example

# start save! example
person = Person.new(
  first_name: "Esmeralda",
  last_name: "Qemal"
)
person.save!

person.first_name = "Malik"
person.save!
# end save! example

# start save example
person = Person.new(
  first_name: "Tamara",
  last_name: "Graham"
)
person.save

person.first_name = "Aubrey"
person.save(validate: false)
# end save example

# start attributes example
person = Person.new(first_name: "James", last_name: "Nan")

person.save

puts person.attributes
# end attributes example

# start reload example
band = Band.create!(name: 'foo')
# => #<Band _id: 6206d06de1b8324561f179c9, name: "foo">

band.name = 'bar'
# => #<Band _id: 6206d06de1b8324561f179c9, name: "bar">

band.reload
# => #<Band _id: 6206d06de1b8324561f179c9, name: "foo">
# end reload example

# start reload unsaved example
existing = Band.create!(name: 'Photek')

band = Band.new(id: existing.id)
band.reload

puts band.name
# end reload unsaved example

# start update attributes! example
person.update_attributes!(
  first_name: "Maximilian",
  last_name: "Hjalmar"
)
# end update attributes! example

# start update attributes example
person.update_attributes(
  first_name: "Hasan",
  last_name: "Emine"
)
# end update attributes example

# start update attribute example
person.update_attribute(:first_name, "Jean")
# end update attribute example

# start upsert example
person = Person.new(
  first_name: "Balu",
  last_name: "Rama"
)
person.upsert

person.first_name = "Ananda"
person.upsert(replace: true)
# end upsert example

# start touch example
person.touch
person.touch(:audited_at)
# end touch example

# start delete example
person.delete

person = Person.create!(...)

unsaved_person = Person.new(id: person.id)
unsaved_person.delete

person.reload
# end delete example

# start destroy example
person.destroy
# end destroy example

# start delete all example
Person.delete_all
# end delete all example

# start destroy all example
Person.destroy_all
# end destroy all example

# start new record example
person = Person.new(
  first_name: "Tunde",
  last_name: "Adebayo"
)
puts person.new_record?

person.save!
puts person.new_record?
# end new record example

# start persisted example
person = Person.new(
  first_name: "Kiana",
  last_name: "Kahananui"
)
puts person.persisted?

person.save!
puts person.persisted?
# end persisted example

# start atomically example
person.atomically do
  person.inc(age: 1)
  person.set(name: 'Jake')
end
# end atomically example

# start default block atomic example
person.atomically do
  person.atomically do
      person.inc(age: 1)
      person.set(name: 'Jake')
  end
  raise 'An exception'
  # Name and age changes are persisted
end
# end default block atomic example

# start join_contexts atomic
person.atomically do
  person.atomically(join_context: true) do
      person.inc(age: 1)
      person.set(name: 'Jake')
  end
  raise 'An exception'
  # Name and age changes are not persisted
end
# end join_contexts atomic