class Word < ActiveRecord::Base
  attr_accessible :meaning, :word
  has_and_belongs_to_many :roots

  def nested_json(parent=nil, depth=0)
    puts 'going- word style============================'
    h = {name: self.word, meaning: self.meaning}
    return h if depth > 1
    depth += 1

    children = self.roots
                    .reject { |r| r==parent }
                    .map{ |r| r.nested_json(self, depth) }
    h[:children] = children unless children.empty?
    h
  end
end
