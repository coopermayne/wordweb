class Word < ActiveRecord::Base
  attr_accessible :meaning, :word
  has_and_belongs_to_many :roots

  def nested_json(parent=nil)
    puts 'WORD nnnnneeeessst'
    h = {name: self.word}
    children = self.roots
                    .reject { |r| r==parent }
                    .map{ |r| {name: r.root_db, children: r.words.sample(3).map { |w| {name: w.word } } } }#r.nested_json(self)
    h[:children] = children unless children.empty?
    h
  end
end
