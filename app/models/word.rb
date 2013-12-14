class Word < ActiveRecord::Base
  attr_accessible :meaning, :word
  has_and_belongs_to_many :roots
end
