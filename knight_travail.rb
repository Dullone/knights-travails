class Board
  def initialize (size = 8)
    @size = size
    @squares = Array.new (@size) { Array.new(@size, false) }
    @total_squares = size**2
    @visited_squares = 0
  end

  def in_bounds?(location)
    location[0] >= 0 && location[0] < @size && location[1] < @size && location[1] >= 0
  end
end

class Knight
  @@moves = {
    :left_1_up_2    => [-1, 2],
    :left_2_up_1    => [-2, 1],
    :left_1_down_2  => [-1,-2],
    :left_2_down_1  => [-2,-1],
    :right_1_down_2 => [ 1,-2],
    :right_2_down_1 => [ 2,-1],
    :right_1_up_2   => [ 1, 2],
    :right_2_up_1   => [ 2, 1]
  }

  def initialize (board)
    @board = board
  end

  #breadth first traversal to find solution in the least moves
  def knight_moves(from, to)
    if from == to
      return to
    end
    queue = []
    #hash for tracking paths taken, initialized with start location
    paths_list = {from.to_s.to_sym => [from]}
    #This tracks if we have made a particular move from the current node
    #values are stored as symbolized node + move type 
    visited = {}
    answers = []
    done = false
    #start location
    queue.push from

    until queue.empty? do
      #get first item in queue
      node = queue.shift

      @@moves.each do |move_type, offset|
        destinaiton = [node[0] + offset[0], node[1] + offset[1]]
      
        if @board.in_bounds?(destinaiton) && !visited[(node.to_s + move_type.to_s).to_sym]
          visited[(node.to_s + move_type.to_s).to_sym] = true
          queue.push destinaiton
      
          #track backward the path taken
          paths_list[destinaiton.to_s.to_sym] = (paths_list[node.to_s.to_sym] + [destinaiton])
          if to == destinaiton
            #add end point the path taken
            answers << paths_list[destinaiton.to_s.to_sym]
            done = true
            break
          end
        end
      end
    end
    answers.min { |ar1, ar2| ar1.length <=> ar2.length }
  end
end

from = [3,3]
to =   [0,0]

puts "From #{from} to #{to}"

knight = Knight.new(Board.new)

answer = knight.knight_moves(from, to)

puts "You made it in #{answer.length} moves!  Path: "
answer.each do |move|
  puts "#{move}"
end