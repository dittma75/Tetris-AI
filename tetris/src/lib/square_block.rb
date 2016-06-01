# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# A SquareBlock represents the Tetromino that
# looks like this:
# ____
# _XX_
# _XX_
# ____

class SquareBlock < Tetromino
  # Constructor
  # param row is the row of the block used to position
  # all other blocks in the SquareBlock.
  # param col is the column of the block used to position
  # all other blocks in the SquareBlock.
  def initialize(row, col)
    @type = SQUARE
    @rotation_type = NO_ROTATION
    
    @blocks = [
      Block.new(row, col),
      Block.new(row, col + 1),
      Block.new(row + 1, col),
      Block.new(row + 1, col + 1)
    ]
  end
  
  # Squares look the same when they rotate left, but
  # Tetrominoes must implement a rotateLeft method
  def rotateLeft()
  
  end
  
  # Squares look the same when they rotate right, but
  # Tetrominoes must implement a rotateRight method
  def rotateRight()
  
  end
end