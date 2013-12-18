class Root < ActiveRecord::Base
  attr_accessible :meaning, :origin, :root, :root_db
  has_and_belongs_to_many :words

  def nested_json(parent=nil, depth=0)
    puts 'going- root style============================'
    depth += 1
    h = {name: self.root_db, meaning: self.meaning}
    children =  self.words
                    .reject { |w| w==parent }
                    .sort_by{|word| word.roots.count}
    children = children[-7,7] || children #seven max 
    children.map!{ |w| w.nested_json(self, depth) }

    h[:children] = children unless children.empty?
    h
  end
end
