require 'colorize'

class AlreadyTaken < StandardError
  def initialize(symbol)
    msg = "That slot is already taken by #{symbol}".red
    super(msg)
  end
end

class OutOfBounds < StandardError
  def initialize(*args)
    msg = "That slot is outside the game board!".red
    super(msg)
  end
end

class GameBoard
  ROWS = 3
  COLUMNS = 3
  ROW_SEPERATOR = "-#{'-' * 2 * COLUMNS}"

  attr_accessor :board

  def initialize
    @board = []
    ROWS.times { board.push(Array.new(COLUMNS)) }
  end

  def mark(x, y, symbol)
    raise OutOfBounds if out_of_bounds?(x, y)
    raise AlreadyTaken.new(board[y][x]) if board[y][x]
    board[y][x] = symbol
  end

  def winner
    horitzontal? ||  vertical? ||  diagonal?
  end

  def full?
    not board.find do |row|
      row.any? { |cell| cell.nil? }
    end
  end

  def draw
    sym = lambda { |val| val ? val : ' ' }

    all_rows = (0...ROWS).map do |row|
      new_row = ''
      new_row << '|'

      (0...COLUMNS).each do |column|
        new_row << sym[board[row][column]]
        new_row << '|'
      end

      new_row
    end

    puts ROW_SEPERATOR
    all_rows.each do |row|
      puts row
      puts ROW_SEPERATOR
    end

    true
  end

  private

  def out_of_bounds?(x, y)
    x >= COLUMNS or y >= ROWS
  end

  def horitzontal?
    winning_set(board)
  end

  def vertical?
    columns = (0...ROWS).map do |i|
      board.map { |row| row[i] }
    end

    winning_set(columns)
  end

  def diagonal?
    left_diagonal = (0...ROWS).map { |i| board[i][i] }
    right_diagonal = (0...ROWS).map { |i| board[i][ROWS - i - 1] }

    winning_set([left_diagonal, right_diagonal])
  end

  def winning_set(set)
    winning_row = set.find do |row|
      row.all? { |cell| cell != nil && cell == row.first  }
    end

    return winning_row.first if winning_row
  end
end
