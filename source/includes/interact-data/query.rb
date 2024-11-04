# start-simple-field-query
Band.where(name: 'Depeche Mode')
Band.where('name' => 'Depeche Mode')
# end-simple-field-query

# start-query-api-query
Band.where(founded: {'$gt' => 1980})
Band.where('founded' => {'$gt' => 1980})
# end-query-api-query

# start-symbol-query
Band.where(:founded.gt => 1980)
# end-symbol-query

# start-defined-field-query
Band.where(founded: '2020')
# end-defined-field-query

# start-raw-field-query
Band.where(founded: Mongoid::RawValue('2020'))
# end-raw-field-query

# start-id-field-query
Band.where(id: '5ebdeddfe1b83265a376a760')
Band.where(_id: '5ebdeddfe1b83265a376a760')
# end-id-field-query

# start-embedded-query
Band.where('manager.name' => 'Smith')
# end-embedded-query

# start-embedded-ne-query
Band.where(:'manager.name'.ne => 'Smith')
# end-embedded-ne-query

# start-logical-ops
# Uses "and" to combine criteria
Band.where(label: 'Trust in Trance').and(name: 'Astral Projection')

# Uses "or" to specify criteria
Band.where(label: 'Trust in Trance').or(Band.where(name: 'Astral Projection'))

# Uses "not" to specify criteria
Band.not(label: 'Trust in Trance', name: 'Astral Projection')

# Uses "not" without arguments
Band.not.where(label: 'Trust in Trance', name: 'Astral Projection')
# end-logical-ops

# start-logical-and-ops
# Conditions passed to separate "and" calls
Band.and(name: 'Sun Kil Moon').and(member_count: 2)

# Multiple conditions in the same "and" call
Band.and({name: 'Sun Kil Moon'}, {member_count: 2})

# Multiple conditions in an array - Deprecated
Band.and([{name: 'Sun Kil Moon'}, {member_count: 2}])

# Condition in "where" and a scope
Band.where(name: 'Sun Kil Moon').and(Band.where(member_count: 2))

# Condition in "and" and a scope
Band.and({name: 'Sun Kil Moon'}, Band.where(member_count: 2))

# Scope as an array element, nested arrays - Deprecated
Band.and([Band.where(name: 'Sun Kil Moon'), [{member_count: 2}]])
# end-logical-and-ops

# start-logical-combination-ops
# Combines as "and"
Band.where(name: 'Swans').where(name: 'Feist')

# Combines as "or"
Band.where(name: 'Swans').or(name: 'Feist')
# end-logical-combination-ops

# start-logical-combination-ops-2
# "or" applies to the first condition, and the second is combined
# as "and"
Band.or(name: 'Sun').where(label: 'Trust')

# Same as previous example - "where" and "and" are aliases
Band.or(name: 'Sun').and(label: 'Trust')

# Same operator can be stacked any number of times
Band.or(name: 'Sun').or(label: 'Trust')

# The last label condition is added to the top level as "and"
Band.where(name: 'Sun').or(label: 'Trust').where(label: 'Feist')
# Interpreted query:
# {"$or"=>[{"name"=>"Sun"}, {"label"=>"Trust"}], "label"=>"Feist"}
# end-logical-combination-ops-2

# start-not-logical
# "not" negates "where"
Band.not.where(name: 'Best')

# The second "where" is added as "$and"
Band.not.where(name: 'Best').where(label: /Records/)

# "not" negates its argument
Band.not(name: 'Best')
# end-not-logical

# start-not-logical-note
# String negation - uses "$ne"
Band.not.where(name: 'Best')
 
# Regex negation - uses "$not"
Band.not.where(name: /Best/)
# end-not-logical-note

# start-not-behavior
# Simple condition
Band.not(name: /Best/)

# Complex conditions
Band.where(name: /Best/).not(name: 'Astral Projection')

# Symbol operator syntax
Band.not(:name.ne => 'Astral Projection')
# end-not-behavior

# start-incremental-1
Band.in(name: ['a']).in(name: ['b'])
# Interpreted query:
# {"name"=>{"$in"=>["a"]}, "$and"=>[{"name"=>{"$in"=>["b"]}}]}
# end-incremental-1

# start-in-merge
Band.in(name: ['a']).override.in(name: ['b'])
# Interpreted query:
# {"name"=>{"$in"=>["b"]}}

Band.in(name: ['a', 'b']).intersect.in(name: ['b', 'c'])
# Interpreted query:
# {"name"=>{"$in"=>["b"]}}

Band.in(name: ['a']).union.in(name: ['b'])
# Interpreted query:
# {"name"=>{"$in"=>["a", "b"]}}
# end-in-merge

# start-merge-reset
Band.in(name: ['a']).union.ne(name: 'c').in(name: ['b'])
# Interpreted query:
# {"name"=>{"$in"=>["a"], "$ne"=>"c"}, "$and"=>[{"name"=>{"$in"=>["b"]}}]}
# end-merge-reset

# start-merge-where
Band.in(name: ['a']).union.where(name: {'$in' => 'b'})
# Interpreted query:
# {"foo"=>{"$in"=>["a"]}, "$and"=>[{"foo"=>{"$in"=>"b"}}]}
# end-merge-where

# start-range-query
Band.in(year: 1950..1960)
# Interpreted query:
# {"year"=>{"$in"=>[1950, 1951, 1952, 1953, 1954, 1955, 1956, 1957, 1958, 1959, 1960]}}
# end-range-query

# start-elem-match-1
aerosmith = Band.create!(name: 'Aerosmith', tours: [
  {city: 'London', year: 1995},
  {city: 'New York', year: 1999},
])

swans = Band.create!(name: 'Swans', tours: [
  {city: 'Milan', year: 2014},
  {city: 'Montreal', year: 2015},
])

# Returns only "Aerosmith"
Band.elem_match(tours: {city: 'London'})
# end-elem-match-1

# start-elemmatch-embedded-class
class Band
    include Mongoid::Document
    field :name, type: String
    embeds_many :tours
end

class Tour
  include Mongoid::Document
  field :city, type: String
  field :year, type: Integer
  embedded_in :band
end
# end-elemmatch-embedded-class

# start-elemmatch-embedded-operations
aerosmith = Band.create!(name: 'Aerosmith')

Tour.create!(band: aerosmith, city: 'London', year: 1995)
Tour.create!(band: aerosmith, city: 'New York', year: 1999)

# Returns the "Aerosmith" document
Band.elem_match(tours: {city: 'London'})
# end-elemmatch-embedded-operations

# start-elemmatch-recursive
class Tag
    include Mongoid::Document

    field name:, type: String
    recursively_embeds_many
end

# Creates the root Tag
root = Tag.create!(name: 'root')

# Adds embedded Tags
sub1 = Tag.new(name: 'sub_tag_1', child_tags: [Tag.new(name: 'sub_sub_tag_1')])

root.child_tags << sub1
root.child_tags << Tag.new(name: 'sub_tag_2')
root.save!

# Searches for Tag in which one child Tag tame is "sub_tag_1"
Tag.elem_match(child_tags: {name: 'sub_tag_1'})

# Searches for a child Tag in which one child Tag tame is "sub_sub_tag_1"
root.child_tags.elem_match(child_tags: {name: 'sub_sub_tag_1'})
# end-elemmatch-recursive

# start-id-query-multiple
# Equivalent ways to match multiple documents
Band.find('5f0e41d92c97a64a26aabd10', '5f0e41b02c97a64a26aabd0e')
Band.find(['5f0e41d92c97a64a26aabd10', '5f0e41b02c97a64a26aabd0e'])
# end-id-query-multiple
