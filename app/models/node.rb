class Node

  # represents 1 node in the d3
  attr_accessor :name, :children, :parent, :id, :type

  def initialize(input) # put in a word/root object
    @name = input.is_a?(Word) ? input.word : input.root_db
    @children = []
    @parent = parent
    @id = input.id
    @type = input.class.to_s
  end

  def to_hash
    h = {name: @name}
    children = @children.map{ |c| c.to_hash }}
    h['children'] = children unless @children.empty?
  end

  def add node
    self.children << node
    node.parent = self
  end

end
