require "tsort"

# Simple wrapper around the "tsort" library, which has a horrible API. The main
# advantage of the wrapper is that you don't need to modify the class that
# represents sorted objects.
#
# Usage:
#
#  class Node
#    attr_accessor :deps
#
#    def initialize(index)
#      @index = index
#    end
#
#    def to_s
#      "n#@index"
#    end
#  end
#
#  n1 = Node.new(1)
#  n2 = Node.new(2)
#  n3 = Node.new(3)
#  n4 = Node.new(4)
#
#  n1.deps = [n2, n3]
#  n2.deps = [n3]
#  n3.deps = []
#  n4.deps = []
#
#  # The passed block is used to get node's dependencies.
#  TSorter.sort([n1, n2, n3, n4]) do |node|
#    node.deps
#  end
#  # => [n3, n2, n1, n4]
#
class TSorter
  include TSort

  def self.sort(nodes, &block)
    self.new(nodes, &block).tsort
  end

  def initialize(nodes, &block)
    @nodes = nodes
    @block = block
  end

  def tsort_each_node(&block)
    @nodes.each(&block)
  end

  def tsort_each_child(node, &block)
    @block.call(node).each(&block)
  end
end
