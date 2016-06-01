# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# A LineBlock represents the Tetromino that
# looks like this:
# __X__
# __X__
# __X__
# __X__

class LineBlock < Tetromino
  # Constructor
  # param row is the row of the block used to position
  # all other blocks in the LineBlock.
  # param col is the column of the block used to position
  # all other blocks in the LineBlock.
  def initialize(row, col)
    @type = LINE
    @rotation_type = TWO_ROTATION

    @blocks = getUnrotatedBlocks(row, col)
    @rotated = false
  end
  
  # Rotate the LineBlock clockwise.  The result is the same as
  # rotating right.
  def rotateLeft()
    twoTypeRotate()
  end
  
  # Rotate the LineBlock counterclockwise.  The result is the same as
  # rotating left.
  def rotateRight()
    twoTypeRotate()
  end

  # param row is the row of the center block
  # param col is the column of the center block
  # return the Block array that represents the rotated
  # Tetromino  
  def getRotatedBlocks(row, col)
    return [
      Block.new(row, col),
      Block.new(row - 1, col),
      Block.new(row + 1, col),
      Block.new(row + 2, col)
    ]
  end

  # param row is the row of the center block
  # param col is the column of the center block
  # return the Block array that represents the unrotated
  # Tetromino 
  def getUnrotatedBlocks(row, col)
    return [
      Block.new(row, col),
      Block.new(row, col - 1),
      Block.new(row, col + 1),
      Block.new(row, col + 2)
    ]
  end
end