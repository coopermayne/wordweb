class Root < ActiveRecord::Base
  attr_accessible :meaning, :origin, :root, :root_db
  has_and_belongs_to_many :words
end
