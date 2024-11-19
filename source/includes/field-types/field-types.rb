# start-define-fields
class Person
  include Mongoid::Document
  field :name, type: String
  field :date_of_birth, type: Date
  field :weight, type: Float
end
# end-define-fields

# start-define-untyped
class Person
  include Mongoid::Document
  
  field :name, type: String
  field :preferences
end
# end-define-untyped

# start-untyped
product = Product.new(properties: "color=white,size=large")
# properties field saved as String: "color=white,size=large"

product = Product.new(properties: {color: "white", size: "large"})
# properties field saved as Object: {:color=>"white", :size=>"large"}
# end-untyped

# start-stringified-symbol
class Post
    include Mongoid::Document
  
    field :status, type: StringifiedSymbol
end
  
# Save status as a symbol
post = Post.new(status: :hello)
# status is stored as "hello" on the database, but returned as a Symbol
post.status
# Outputs: :hello

# Save status as a string
post = Post.new(status: "hello")
# status is stored as "hello" in the database, but returned as a Symbol
post.status
# Outputs: :hello
# end-stringified-symbol

# start-hash
class Person
    include Mongoid::Document
    field :first_name
    field :url, type: Hash
  
    def set_vals
      self.first_name = 'Daniel'
      self.url = {'home_page' => 'http://www.homepage.com'}
      save
end
# end-hash

# start-time
class Voter
    include Mongoid::Document
  
    field :registered_at, type: Time
end
  
  Voter.new(registered_at: Date.today)
# end-time

# start-datetime
class Ticket
    include Mongoid::Document
    field :opened_at, type: DateTime
end
# end-datetime

# start-datetime-int
ticket.opened_at = 1544803974
ticket.opened_at
# Outputs: Fri, 14 Dec 2018 16:12:54 +0000
# end-datetime-int

# start-datetime-string
ticket.opened_at = 'Mar 4, 2018 10:00:00 +01:00'
ticket.opened_at
# Outputs: Sun, 04 Mar 2018 09:00:00 +0000
# end-datetime-string

# start-timestamps
class Person
  include Mongoid::Document
  include Mongoid::Timestamps
end
# end-timestamps

# start-timestamps-specific
class Person
  include Mongoid::Document
  include Mongoid::Timestamps::Created
end

class Post
  include Mongoid::Document
  include Mongoid::Timestamps::Updated
end
# end-timestamps-specific

# start-timestamps-disable
person.timeless.save
# end-timestamps-disable

# start-timestamps-short
class Band
  include Mongoid::Document
  include Mongoid::Timestamps::Short # For c_at and u_at.
end

class Band
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short # For c_at only.
end

class Band
  include Mongoid::Document
  include Mongoid::Timestamps::Updated::Short # For u_at only.
end
# end-timestamps-short

# start-regexp
class Token
    include Mongoid::Document
  
    field :pattern, type: Regexp
end
  
token = Token.create!(pattern: /hello.world/m)
token.pattern
# Outputs: /hello.world/m

# Reload the token from the database
token.reload
token.pattern
# Outputs: #<BSON::Regexp::Raw:0x0000555f505e4a20 @pattern="hello.world", @options="ms">
# end-regexp

# start-field-default
class Order
    include Mongoid::Document
  
    field :state, type: String, default: 'created'
end
# end-field-default

# start-field-default-processed
class Order
    include Mongoid::Document
  
    field :fulfill_by, type: Time, default: ->{ Time.now + 3.days }
end
# end-field-default-processed

# start-field-default-self
field :fulfill_by, type: Time, default: ->{
    self.submitted_at + 4.hours
}
# end-field-default-self

# start-field-default-pre-processed
field :fulfill_by, type: Time, default: ->{ Time.now + 3.days },
  pre_processed: true
# end-field-default-pre-processed

# start-field-as
class Band
    include Mongoid::Document
    field :n, as: :name, type: String
end
# end-field-as

# start-field-alias
class Band
    include Mongoid::Document
    field :name, type: String
    alias_attribute :n, :name
end
# end-field-alias

# start-field-unalias
class Band
    unalias_attribute :n
end
# end-field-unalias

# start-field-overwrite
class Person
    include Mongoid::Document
    field :name
    field :name, type: String, overwrite: true
end
# end-field-overwrite

# start-custom-id
class Band
    include Mongoid::Document
    field :name, type: String
    field :_id, type: String, default: ->{ name }
end
# end-custom-id

# start-custom-getter-setter
class Person
    include Mongoid::Document
    field :name, type: String

    # Custom getter for 'name' to return the name in uppercase
    def name
      read_attribute(:name).upcase if read_attribute(:name)
    end
  
    # Custom setter for 'name' to store the name in lowercase
    def name=(value)
      write_attribute(:name, value.downcase)
    end
  end
# end-custom-getter-setter

# start-custom-field-type
class Point

  attr_reader :x, :y
  
  def initialize(x, y)
    @x, @y = x, y
  end
  
  # Converts an object of this instance into an array
  def mongoize
    [ x, y ]
  end
  
  class << self
  
    # Takes any possible object and converts it to how it is
    # stored in the database.
    def mongoize(object)
      case object
      when Point then object.mongoize
      when Hash then Point.new(object[:x], object[:y]).mongoize
      else object
      end
    end
  
    # Gets the object as it's stored in the database and instantiates
    # this custom class from it.
    def demongoize(object)
      if object.is_a?(Array) && object.length == 2
          Point.new(object[0], object[1])
      end
    end
  
    # Converts the object supplied to a criteria and converts it
    # into a queryable form.
    def evolve(object)
      case object
      when Point then object.mongoize
      else object
      end
    end
  end
end
# end-custom-field-type

# start-phantom-field-type
class ColorMapping

  MAPPING = {
    'black' => 0,
    'white' => 1,
  }.freeze

  INVERSE_MAPPING = MAPPING.invert.freeze

  class << self

    def mongoize(object)
      MAPPING[object]
    end

    def demongoize(object)
      INVERSE_MAPPING[object]
    end

    def evolve(object)
      MAPPING.fetch(object, object)
    end
  end
end

class Profile
  include Mongoid::Document
  field :color, type: ColorMapping
end

profile = Profile.new(color: 'white')
profile.color
# Outputs: "white"

# Writes 0 to the database
profile.save!
# end-phantom-field-type

# start-dynamic-field
class Person
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
end
# end-dynamic-field

# start-reserved-characters
class User
  include Mongoid::Document
  field :"first.last", type: String
  field :"$_amount", type: Integer
end

user = User.first
user.send(:"first.last")
# Outputs: Mike.Trout
user.send(:"$_amount")
# Outputs: 42650000
# end-reserved-characters

# start-localized-field
class Product
  include Mongoid::Document
  field :review, type: String, localize: true
end

I18n.default_locale = :en
product = Product.new
product.review = "Marvelous!"
I18n.locale = :de
product.review = "Fantastisch!"

product.attributes
# Outputs: { "review" => { "en" => "Marvelous!", "de" => "Fantastisch!" }
# end-localized-field

# start-localized-translations
product.review_translations
# Outputs: { "en" => "Marvelous!", "de" => "Fantastisch!" }
product.review_translations =
  { "en" => "Marvelous!", "de" => "Wunderbar!" }
# end-localized-translations

# start-localized-fallbacks
config.i18n.fallbacks = true
config.after_initialize do
  I18n.fallbacks[:de] = [ :en, :es ]
end
# end-localized-fallbacks

# start-localized-fallbacks-non-rails
require "i18n/backend/fallbacks"
I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
I18n.fallbacks[:de] = [ :en, :es ]
# end-localized-fallbacks-non-rails

# start-localized-no-fallbacks
class Product
  include Mongoid::Document
  field :review, type: String, localize: true, fallbacks: false
end
# end-localized-no-fallbacks

# start-localized-query
# Match all products with Marvelous as the review. The current locale is :en.
Product.where(review: "Marvelous!")
# The resulting MongoDB query filter: { "review.en" : "Marvelous!" }
# end-localized-query

# start-read-only
class Band
  include Mongoid::Document
  field :name, type: String
  field :origin, type: String

  attr_readonly :name
end
# end-read-only