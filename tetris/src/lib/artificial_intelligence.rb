# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# ArtificialIntelligence is the class that will
# contain all of the information for playing Tetris.
#
# As of now, it is a giant stub because Tetris is not
# quite in a playable state.

# Approach:  The current state of the board will be fed
# into the getBestMove() function, which will evaluate
# the heuristics for each potential move (rotations
# included) for a Tetris block.  Heuristics will be calculated
# by the heuristic() function.  The move sequence returned by
# getBestMove() will be the best move according to the heuristics.

class ArtificialIntelligence
  # Row number that tells the AI that it is close to losing
  NEAR_DEATH_THRESHOLD = 11
  
  # Row number that tells the AI that it shouldn't be taking
  # risks to improve its score
  UNSAFE_THRESHOLD = 16
  
  # Constructor
  # param board is the board to use for deciding on a move
  # param tetromino is the tetromino that needs to be placed on the board
  # by the ArtificialIntelligence.
  def initialize(board, tetromino)
    # Make a copy of the board and tetromino for us to safely use
    @board = DeepClone.clone(board)
    @tetromino = DeepClone.clone(tetromino)
    
    # Clear the tetromino from the board just to make sure.
    @board.removeTetromino(@tetromino)
    
    # Move the tetromino down so there's room to rotate it
    @tetromino.moveDown()
    
    # The reward row awards positive points to a tetromino placement that is
    # at or below this row.
    @reward_row = getHighestOccupiedRow()
    
    # An arbitrarily bad starting heuristic
    @best_heuristic = -999999
    @best_move = Array.new()
  end
  
  # return an array containing the best move sequence and the time
  # that it took to do the move calculation.  The time will be used
  # to do the proper number of gravity moves.
  def getBestMove()
    # Get the highest row (closest to 0) with a non-empty
    # block.  This is the top of the reward area.
    
    # Iterate through all options for the tetromino with
    # each rotation considered.
    
    # Must be done without the Tetromino on the board because it will mess it up.
    start = Time.now
    
    # Figure out how many orientations we have to try for this tetromino.
    rotation = 1
    case (@tetromino.getRotationType())
    when Tetromino::NO_ROTATION
      rotation = 1
    when Tetromino::TWO_ROTATION
      rotation = 2
    when Tetromino::FOUR_ROTATION
      rotation = 4
    else
      abort("No rotation type specified for type #{@type} tetromino")
    end
    
    # We have to check every possible rotation of the tetromino.
    for rot in 0...rotation
      tryMoves(rot)
      @tetromino.rotateLeft()
    end
    
    elapsed_time = Time.now - start
    return @best_move, elapsed_time
  end

  # Try all possible moves for the given rotation of the tetromino
  # param rotation is the rotation to use for the tetromino in this
  # set of attempted moves
  # Note:  The best move sequence found will be stored in @best_move,
  # and that move's heuristic will be stored in @best_heuristic when this
  # function finishes executing.
  def tryMoves(rotation)
    # Make a copy of the tetromino so we don't mess up later rotations if
    # there are any.
    tetromino_copy = DeepClone.clone(@tetromino)
    
    sideways_moves = 0
    
    # Keep track of the last good move so we can reset to it
    # when we go too far.
    previous_tetromino = DeepClone.clone(tetromino_copy)
    # move the tetromino as far left as possible
    while (tetromino_copy.moveLeft() and
           !@board.causesCollision?(tetromino_copy))
      sideways_moves -= 1
      previous_tetromino.moveLeft()
    end
    # tetromino went too far, so reset to previous_tetromino
    tetromino_copy = previous_tetromino
    
    begin
      down_moves = 0
      next_tet = DeepClone.clone(tetromino_copy)
      previous_tetromino = DeepClone.clone(next_tet)
      while (next_tet.moveDown() and !@board.causesCollision?(next_tet))
        down_moves += 1
        previous_tetromino.moveDown()
      end
      # next_tet went too far, so reset to previous_tetromino
      next_tet = previous_tetromino
      
      # Add the tetromino to the board to do the heuristic
      @board.addTetromino(next_tet)
      
      next_heuristic = getHeuristic(next_tet)
      # If this move is better than the current best, set the heuristic and
      # the instructions for making a better move.
      if (next_heuristic > @best_heuristic)
        @best_heuristic = next_heuristic
        @best_move = [rotation, sideways_moves, down_moves]
      end
      sideways_moves += 1
      @board.removeTetromino(next_tet)
    end while (tetromino_copy.moveRight())
  end
  
  # This function will evaluate a move based on the given tetromino's
  # placement on the board.  It will consider:
  #   holes beneath the tetromino
  #   lines made by the move
  #   blocks within the designated reward zone (below the highest block
  #     on the board before the move)
  #   the distance between each tetromino block and the top of the reward
  #     zone
  #   deep wells on the board (columns with 3 or more contiguous empty spaces)
  #   moves that prematurely place a tetromino close to the top of the board.
  # param tetromino is the tetromino location to use for the heuristic.
  # return the heuristic value given the board, tetromino, and reward row.
  def getHeuristic(tetromino)
    heuristic = getHolesBelowTetromino(tetromino) +
                getLinesMade(tetromino) +
                getBlocksInRewardZone(tetromino) +
                getHeightModifier(tetromino) +
                checkForDeepWells(tetromino) +
                checkForNearDeathPlacement(tetromino)
    return heuristic
  end
  
  # param tetromino is the tetromino location to use for the heuristic.
  # return the number of holes below each block of the tetromino.
  # Note:  holes will be double counted for blocks of a tetromino in the
  # same column.
  def getHolesBelowTetromino(tetromino)
    # Add the temp tetromino to the board to calculate the heuristic.
    @board.addTetromino(tetromino)
    negative_h = 0
    tetromino.getBlocks().each do |block|
      column = @board.getColumnBelowRow(block.getRow(), block.getColumn()).first(2)
      column.each do |cell|
        if (cell == Tetromino::EMPTY)
          negative_h -= 1
        else
          break
        end
      end
    end
    # Remove the temp tetromino from the board so it doesn't mess up
    # other heuristics.
    @board.removeTetromino(tetromino)
    if (getHighestOccupiedRow() >= UNSAFE_THRESHOLD)
      return negative_h * 800
    else
      return negative_h * 35
    end
  end

  # return the index of the highest non-empty row on the Board.
  # Note:  higher rows have lower indices.
  def getHighestOccupiedRow()
    for i in 0...Board::ROWS
      row = @board.getBoard()[i]
      if (row.count(Tetromino::EMPTY) < row.count())
        return i
      end
    end
    return Board::ROWS
  end
  
  # param tetromino is the tetromino location to use for the heuristic.
  # param reward_row is the highest occupied row before the tetromino is placed.
  # return the number of blocks that are part of the tetromino and within the
  # reward zone multiplied by 5
  def getBlocksInRewardZone(tetromino)
    positive_h = 0
    tetromino.getBlocks().each do |block|
      if (block.getRow() >= @reward_row)
        positive_h += 1
      end
    end
    return positive_h * 5
  end
  
  # param tetromino is the tetromino location to use for the heuristic.
  # return an almost arbitrarily large heuristic value (10000 * lines made)
  # if the AI is in danger of losing or can make a really high scoring move,
  # or a relatively high-weighted move based on the height of the board
  def getLinesMade(tetromino)
    row_indices = Array.new()
    tetromino.getBlocks().each do |block|
      unless (row_indices.include?(block.getRow()))
        row_indices.push(block.getRow())
      end
    end
    
    lines_made = 0
    # We need to add the tetromino to the board to see if it made lines.
    @board.addTetromino(tetromino)
    row_indices.each do |row|
      if (@board.isLine?(@board.getBoard()[row]))
        lines_made += 1
      end
    end
    # Reset the board to how it was.
    @board.removeTetromino(tetromino)
    
    # Making lines becomes a very high priority when the highest row is
    # dangerously close to the top (higher row on the board means lower index number).
    # Big-scoring moves that make 3 or 4 lines are also prioritized.
    highest_row = getHighestOccupiedRow()
    if (lines_made >= 3 or highest_row <= NEAR_DEATH_THRESHOLD)
      return lines_made * 10000
    else
      return lines_made * (Board::ROWS - highest_row) * 40
    end
  end
  
  # Try to keep the board of an even height.
  # param tetromino is the tetromino location to use for the heuristic.
  # return a heuristic value that favors tetrominoes below the reward row
  # rather than above it.
  def getHeightModifier(tetromino)
    height_modifier = 0
    tetromino.getBlocks().each do |block|
      # reward row should be height than block row for good moves
      # higher numbers are lower on the board, so we subtract the reward row
      # from the block row.
      height_modifier += (block.getRow() - @reward_row)
    end
    return height_modifier * 2
  end
  
  # Get a heuristic value based on the number of columns below the reward row
  # with 3 or more contiguous empty cells.
  # param tetromino is the tetromino location to use for the heuristic.
  # return the heuristic value based on the number of deep wells
  def checkForDeepWells(tetromino)
    @board.addTetromino(tetromino)
    deep_wells = 0
    for col_index in 0...Board::COLUMNS
      column = @board.getColumnBelowRow(@reward_row, col_index)
      
      # Keep a count of the contiguous empty cells.  A deep well
      # is a column of holes 3 cells long or larger.
      empty_cell_count = 0
      column.each do |cell|
        # If the cell is empty, add to the contiguous cell count.
        # Otherwise, reset the count.
        if (cell == Tetromino::EMPTY)
          empty_cell_count += 1
        else
          empty_cell_count = 0
        end
        
        # There's a deep well in this column.  Mark it and
        # start checking the next column.
        if (empty_cell_count >= 4)
          deep_wells += 1
          empty_cell_count = 0
          break
        end
      end
    end
    
    @board.removeTetromino(tetromino)
    return -40 * deep_wells * deep_wells
  end
  
  # Prioritize against placing blocks within the first 7 rows of the
  # top of the board because it can cause the AI to build a tower
  # to its premature death.
  # param tetromino is the tetromino location to use for the heuristic.
  # return -150 if a tetromino block is near the top of the board and 0
  # otherwise.
  def checkForNearDeathPlacement(tetromino)
    tetromino.getBlocks().each do |block|
      if (block.getRow() <= UNSAFE_THRESHOLD)
        return -150
      end
    end
    
    return 0
  end
end