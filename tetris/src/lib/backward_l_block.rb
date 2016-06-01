# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# A BackwardLBlock represents the Tetromino that
# looks like this:
# __X__
# __X__
# _XX__
# _____

class BackwardLBlock < Tetromino
  # Constructor
  # param row is the row of the block used to position
  # all other blocks in the BackwardLBlock.
  # param col is the column of the block used to position
  # all other blocks in the BackwardLBlock.
  def initialize(row, col)
    @type = BACKWARD_L
    @orientation_index = 0
    @rotation_type = FOUR_ROTATION
    @blocks = getOrientation(row, col)
  end
  
  
  # Rotate the BackwardLBlock clockwise.  The result is the same as
  # rotating left.
  def rotateLeft()
    fourTypeRotate(Tetromino::CLOCKWISE)
  end
  
  # Rotate the BackwardLBlock counterclockwise.  The result is the same as
  # rotating left.
  def rotateRight()
    fourTypeRotate(Tetromino::COUNTERCLOCKWISE)
  end
  
  # param row is the row of the center reference Block
  # param col is the column of the center reference Block
  # return an array of four Blocks that represent the orientation
  # of the Tetromino
  def getOrientation(row, col)
    case (@orientation_index)
    when 0
      return [
        Block.new(row, col),
        Block.new(row, col - 1),
        Block.new(row, col + 1),
        Block.new(row + 1, col + 1)
      ]
    when 1
      return [
        Block.new(row, col),
        Block.new(row + 1, col - 1),
        Block.new(row + 1, col),
        Block.new(row - 1, col)
      ]
    when 2
      return [
        Block.new(row, col),
        Block.new(row, col - 1),
        Block.new(row - 1, col - 1),
        Block.new(row, col + 1)
      ]
    when 3
      return [
        Block.new(row, col),
        Block.new(row + 1, col),
        Block.new(row - 1, col),
        Block.new(row - 1, col + 1)
      ]
    else
      abort('No such rotation orientation')
    end
  end
end