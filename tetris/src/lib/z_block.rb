# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# A ZBlock represents the Tetromino that
# looks like this:
# _____
# _XX__
# __XX_
# _____

class ZBlock < Tetromino    
  # Constructor
  # param row is the row of the block used to position
  # all other blocks in the ZBlock.
  # param col is the column of the block used to position
  # all other blocks in the ZBlock.
  def initialize(row, col)
    @type = Z
    @rotation_type = TWO_ROTATION
    @blocks = getUnrotatedBlocks(row, col)
    @rotated = false
  end
  
  
  # Rotate the ZBlock clockwise.  The result is the same as
  # rotating right.
  def rotateLeft()
    twoTypeRotate()
  end
  
  # Rotate the ZBlock counterclockwise.  The result is the same as
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
      Block.new(row + 1, col),
      Block.new(row, col + 1),
      Block.new(row - 1, col + 1)
    ]
  end
  
  # param row is the row of the center block
  # param col is the column of the center block
  # return the Block array that represents the unrotated
  # Tetromino
  def getUnrotatedBlocks(row, col)
    return [
      Block.new(row, col),
      Block.new(row + 1, col),
      Block.new(row + 1, col + 1),
      Block.new(row, col - 1)
    ]
  end
end