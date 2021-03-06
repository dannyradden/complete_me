require 'pry'
class CompleteMe

  attr_reader :root_node, :counter

  def initialize
    @root_node = Node.new('')
    @counter = 0
  end

  def insert(word, node = root_node)
    if word.length != 0
      first_letter = word[0]
      remainder = word[1..-1]
      if node.children[first_letter] == nil
        node.children[first_letter] = Node.new(node.node_word + first_letter)
      end
      node.children[first_letter].insert(remainder, node.children[first_letter])
    else
      @terminate = true
    end
  end

  def count(node = root_node)
    node.children.each_value do |value|
      @counter += 1 if value.terminate == true && value != nil
      count(value)
    end
    counter
  end

  def insert_words words
    words.each do |word|
      insert word
    end
  end

  def populate(file_contents)
    insert_words(file_contents.split("\n"))
  end

  def suggest(subscript, node = root_node, apply_sub = true)
    @@sugg_subscript = subscript if apply_sub == true
    @@weighted_suggestions = []
    @@suggestions = []
    if subscript.length != 0
      first_letter = subscript[0]
      remainder = subscript[1..-1]
      if node.children[first_letter] == nil
        'No word in this dictionary starts with the given subscript.'
      else
        node.children[first_letter].suggest(remainder, node.children[first_letter], false)
      end
    else
      add_words_to_sugg
      sort_and_combine_suggestions
    end
  end

  def add_words_to_sugg
    if terminate == true
      if weight[@@sugg_subscript] != nil
        @@weighted_suggestions << weight[@@sugg_subscript].to_s + node_word
      else
        @@suggestions << node_word
      end
    end
    children.each_value do |value|
      value.add_words_to_sugg
    end
  end

  def sort_and_combine_suggestions
    @@suggestions.sort!
    @@weighted_suggestions.sort_by! do |element|
      element.delete("^0-9","^-").to_i
    end
    @@weighted_suggestions.map! { |element| element.delete("^a-z")}
    @@weighted_suggestions += @@suggestions
  end


  def select(substring, word)
    compile_string = "root_node"
    word.each_char do |letter|
      compile_string += '.children["' + letter + '"]'
    end
    evaluate_string = compile_string + '.weight["' + substring + '"]'
    if eval(evaluate_string) == nil
      eval(evaluate_string + "= -1")
    else
      eval(evaluate_string + "-= 1")
    end
  end
end



class Node < CompleteMe
  attr_accessor :children, :terminate, :node_word, :weight
  def initialize(node_word)
    @terminate = false
    @children = {}
    @node_word = node_word
    @weight = {}
  end
end

#cm = CompleteMe.new
# cm.insert_words(["pizza", "pizzeria", "pizzicato", "pizzle", "pize"])
# cm.insert_words ['heck', 'hello', 'h', 'had', 'happy', 'happen', 'happe']
#cm.populate(File.read("./lib/medium.txt"))
# cm.populate(File.read('/usr/share/dict/words'))
# puts cm.select("doggerel", "doggerelist")
# puts ""
# puts cm.suggest('doggerel')

# cm.select("piz", "pizzeria")
# cm.select("piz", "pizzeria")
# cm.select("piz", "pizzeria")
# cm.select("pi", "pizza")
# cm.select("pi", "pizza")
# cm.select("pi", "pizzicato")

# puts cm.suggest("piz")
# puts ""
# puts cm.suggest("pi")
# puts cm.suggest('ba')

# binding.pry
# puts ""

# puts "\n"
# puts "Words in dictionary:#{cm.count}"
