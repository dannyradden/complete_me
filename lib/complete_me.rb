require 'pry'

class CompleteMe

  attr_reader :root_node

  def initialize
    @root_node = Node.new('')
    @@counter = 0
    @@suggestions = ''
  end

  def insert word
    first_letter = word[0]
    remainder = word[1..-1]

    if root_node.children[first_letter] == nil
      root_node.children[first_letter] = Node.new(first_letter)
    end
    root_node.children[first_letter].insert_node(remainder)
  end

  def count
    root_node.children.each_value do |value|
      @@counter += 1 if value.terminate == true && value != nil
      value.count_node
    end
    @@counter
  end

  def insert_words words
    words.each do |word|
      insert word
    end
  end

  def populate(file_contents)
    insert_words(file_contents.split("\n"))
  end

  def suggest(subscript)
    first_letter = subscript[0]
    remainder = subscript[1..-1]

    if root_node.children[first_letter] == nil
      puts 'No word in this dictionary starts with the given subscript.'
    else
      root_node.children[first_letter].suggest_node(remainder)
    end
    print "------\nPossible Words:\n#{@@suggestions} \n------"
  end
end


class Node < CompleteMe

  attr_reader :children, :terminate, :node_word

  def initialize(node_word)
    @terminate = false
    @children = {}
    @node_word = node_word
  end

  def insert_node(rest_of_word)
    if rest_of_word.length != 0
      first_letter = rest_of_word[0]
      remainder = rest_of_word[1..-1]
      if children[first_letter] == nil
        children[first_letter] = Node.new(node_word + first_letter)
      end
      children[first_letter].insert_node(remainder)
    else
      @terminate = true
    end
  end

  def suggest_node(rest_of_word)
    if rest_of_word.length != 0
      first_letter = rest_of_word[0]
      remainder = rest_of_word[1..-1]
      if children[first_letter] == nil
        puts 'No word in this dictionary starts with the given subscript.'
      else
        children[first_letter].suggest_node(remainder)
      end
    else
      add_words_to_sugg
    end
  end

  def add_words_to_sugg
    children.each_value do |value|
      if value.terminate == true && value != nil
        @@suggestions += value.node_word + ' '
      end
      value.add_words_to_sugg
    end
  end

  def count_node
    children.each_value do |value|
      @@counter += 1 if value.terminate == true && value != nil
      value.count_node
    end
  end
end



cm = CompleteMe.new
#cm.insert_words(['hey', 'apple', 'help'])
#cm.insert_words ['a', 'Banana', 'hey', 'hello']
#cm.populate(File.read("./lib/medium.txt"))
cm.populate(File.read('/usr/share/dict/words'))
cm.suggest(gets.chomp)
puts "\n"
puts "Words in dictionary:#{cm.count}"
