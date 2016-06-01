# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# A Block is a cell that is the smallest part of a
# Tetris Board.  Tetrominoes are made of exactly four
# Blocks.

class Block
  # A block is 16 pixels wide
  BLOCK_WIDTH = 16
  # A block is 16 pixels high
  BLOCK_HEIGHT = 16
  
  # Constructor
  # param row is the row of the Block in the Board
  # param col is the column of the Block in the Board
  def initialize(row, col)
    @row = row
    @column = col
  end
  
  # Move the Block left on the Board if possible.
  def moveLeft()
    if (@column > 0)
      @column -= 1
    end
  end

  # Move the Block right on the Board if possible.  
  def moveRight()
    if (@column < Board::COLUMNS - 1)
      @column += 1
    end
  end
  
  # Move the Block down on the Board if possible.
  def moveDown()
    if (@row < Board::ROWS - 1)
      @row += 1
    end
  end
  
  # return the row that this Block is in on the Board.
  def getRow()
    return @row
  end
  
  # return the column that this Block is in on the Board.
  def getColumn()
    return @column
  end
end