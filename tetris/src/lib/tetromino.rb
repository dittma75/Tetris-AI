# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# Used by Tetrominoes to save an "undo" copy of themselves.
require('deep_clone')

# Tetromino is the class that represents
# a generic tetromino, which is a shape made up
# of four squares called blocks.  Each tetromino
# can be moved left, right, and down and has a
# specific type.
class Tetromino
  # Represents an empty cell
  EMPTY = 0
  # Represents a cell filled with a Square tetromino's block
  SQUARE = 1
  # Represents a cell filled with a Line tetromino's block
  LINE = 2
  # Represents a cell filled with a T tetromino's block
  T = 3
  # Represents a cell filled with an L tetromino's block
  L = 4
  # Represents a cell filled with a backward L tetromino's block
  BACKWARD_L = 5
  # Represents a cell filled with a Z tetromino's block
  Z = 6
  # Represents a cell filled with an S tetromino's block
  S = 7
  
  # Represents a clockwise (left) rotation
  CLOCKWISE = true
  # Represents a counter-clockwise (right) rotation
  COUNTERCLOCKWISE = false
  
  # Represents the rotation type for tetrominoes that are
  # the same when rotated (Squares)
  NO_ROTATION = 8
  # Represents the rotation type for tetrominoes that have
  # two unique orientations (S, Z, and Line)
  TWO_ROTATION = 9
  # Represents the rotation type for tetrominoes that have
  # four unique orientations (L, Backward L, and T)
  FOUR_ROTATION = 10
  
  # The number of Tetrominoes.  EMPTY is not included in
  # this count because it represents empty space on the board.
  NUMBER_TETROMINOS = 7

  # Tetromino does not have an initialize function because it
  # should not be instantiated.  It is strictly a superclass for
  # commonality between all Tetrominoes.
  
  # Move every block in the Tetromino to the left
  # one unit.
  # return true if the move was successful (no block
  # is in the same position as it was before the move) and
  # false otherwise
  def moveLeft()
    @blocks.each do |block|
      old_col = block.getColumn()
      block.moveLeft()
      
      if (old_col == block.getColumn())
        return false
      end
    end
    return true
  end
  
  # Move every block in the Tetromino to the right
  # one unit.
  # return true if the move was successful (no block
  # is in the same position as it was before the move) and
  # false otherwise
  def moveRight()
    @blocks.each do |block|
      old_col = block.getColumn()
      block.moveRight()
      
      if (old_col == block.getColumn())
        return false
      end
    end
    return true
  end
  
  # Move every block in the Tetromino to downward
  # one unit.
  # return true if the move was successful (no block
  # is in the same position as it was before the move) and
  # false otherwise
  def moveDown()
    @blocks.each do |block|
      old_row = block.getRow()
      block.moveDown()
      
      if (old_row == block.getRow())
        return false
      end
    end
    return true
  end
  
  # Rotates the tetromino clockwise.
  def rotateLeft()
    #Children must implement this method themselves
  end
  
  # Rotates the tetromino counter-clockwise
  def rotateRight()
    #Children must implement this method themselves
  end
  
  # return the list of blocks that make up this Tetromino
  def getBlocks()
    return @blocks
  end
  
  # return the type of this Tetromino (eg SQUARE, LINE, etc.)
  def getType()
    return @type
  end
  
  # return the rotation type for this Tetromino (none, two, or four)
  def getRotationType()
    return @rotation_type
  end
  
  # Helper that does the actual rotation for blocks
  # with only two orientations, since rotateLeft and 
  # rotateRight do the same things.
  #
  # Note:  @blocks, @rotated, getUnrotatedBlocks(row, col),
  # and getRotatedBlocks(row, col) must be defined by the
  # children.
  def twoTypeRotate()
    old_blocks = DeepClone.clone(@blocks)
    old_rotated = @rotated
    center_block = @blocks.first()
    ref_row = center_block.getRow()
    ref_col = center_block.getColumn()
    
    if (@rotated)
      @blocks = getUnrotatedBlocks(ref_row, ref_col)
    else
      @blocks = getRotatedBlocks(ref_row, ref_col)
    end
    @rotated = !@rotated
    
    @blocks.each do |block|
      row = block.getRow()
      col = block.getColumn()
      if (row < 0 or col < 0 or 
          row >= Board::ROWS or
          col >= Board::COLUMNS)
        @blocks = old_blocks
        @rotated = old_rotated
        break
      end
    end
  end
  
  # Helper that does the actual rotation for blocks
  # with four complex orientations, since rotateLeft and 
  # rotateRight do the same things.
  # param direction is the direction of the rotation (clockwise or
  # counterclockwise)
  #
  # Note:  @blocks, @orientation_index, and getOrientation(row, col)
  # must be defined by the children.
  def fourTypeRotate(direction)
    old_blocks = DeepClone.clone(@blocks)
    old_index = @orientation_index
    center_block = @blocks.first()
    ref_row = center_block.getRow()
    ref_col = center_block.getColumn()
    
    if (direction == CLOCKWISE)
      @orientation_index = (@orientation_index + 1) % 4
    else
      @orientation_index = ((@orientation_index - 1) + 4) % 4
    end
    @blocks = getOrientation(ref_row, ref_col)
    
    @blocks.each do |block|
      row = block.getRow()
      col = block.getColumn()
      if (row < 0 or col < 0 or 
          row >= Board::ROWS or
          col >= Board::COLUMNS)
        @blocks = old_blocks
        @orientation_index = old_index
        break
      end
    end
  end
end