class Node
    attr_reader :id
    attr_accessor :possible_moves, :prev
    def initialize(id)
        @id = id 
        @possible_moves = []
        @prev = nil
    end 
end 

class Board 
    KNIGHT_MOVES = [ [2,1], [2,-1], [-2,1], [-2,-1], [1,2], [1,-2], [-1,2], [-1,-2] ]
    attr_reader :n, :nodes

    def initialize(n) # create n x n board
        @n = n
        @nodes = []
        x = 0 
        y = 0
        until nodes.length == n*n 
            nodes << Node.new([x,y])
            y += 1
            if y == n
                x += 1       # give each node proper coordinates
                y = 0
            end 
        end 
        nodes.each do |node|
            KNIGHT_MOVES.each do |move|
                add_possible_move(move[0], move[1], node) # give each node their possible knight moves
            end
        end     
    end 

    def show_board(path = nil)
        nodes.each do |node|
            if path != nil && path.include?(node.id) 
                print "\e[33m[#{node.id[0]}**#{node.id[1]}] \e[0m"
            else
                print "#{node.id} "
            end  
            puts if node.id[1] == 7
        end 
    end 

    def get_node(id)
        nodes.each { |node| return node if node.id == id }
    end

    def adj_list
        nodes.each { |node| puts "#{node.id} => #{node.possible_moves}" }
    end 

    def bfs(start = [0,0])
        explored = []
        has_prev = [start]
        queue = [start]
        until queue == []
            if explored.include?(queue.first)
                queue.shift 
            else
                get_node(queue.first).possible_moves.each do |move| 
                    get_node(move).prev = queue.first unless has_prev.include?(move)
                    has_prev << move
                    queue << move
                end 
                explored << queue.first
                queue.shift
            end
        end 
        explored
    end 

    def shortest_path(s, e)
        bfs(s) # run bfs function to give nodes proper prev(ious) nodes
        path = [e]
        curr = get_node(e)
        until curr.id == s
            curr = get_node(curr.prev)
            path << curr.id
        end
        path.reverse
    end 

    private
    def add_possible_move(x, y, node)
        node.possible_moves << [node.id[0] + x, node.id[1] + y] unless node.id[0] + x > n-1 || node.id[0] + x < 0 || node.id[1] + y > n-1 || node.id[1] + y < 0
    end  
end 

b = Board.new(8)

path = b.shortest_path([3,3], [4,3])

b.show_board(path)
p path
p "You made it in #{path.length-1} moves"