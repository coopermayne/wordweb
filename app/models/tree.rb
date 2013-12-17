require_relative "node"

class Tree
  attr_reader :root

  def initialize node=Node.new(Root.first)
    @root = node
    @branches = 0
    initial_data
  end

  def initial_data
    branch(@root)
  end

  #extend branch from given node
  def branch node
    @branches += 1
    if node.type == "Word"
      roots = Word.find(node.id).roots
      children = roots.sample(5).map { |root| Node.new(root) }.reject do |c| 
        node.parent.nil? || c.id==node.parent.id
      end
    else
      words = Root.find(node.id).words
      children = words.sample(5).map { |word| Node.new(word) }.reject { |c| node.parent.nil? || c.id==node.parent.id }
    end
    children.each { |child| node.add child }
  end

  def recursive_branching n
    return false if @branches > 5
    @branches += 1

  end

  #def to_hash
    #h = Hash.new
  #end

end
