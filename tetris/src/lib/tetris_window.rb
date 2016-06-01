# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

require('gosu')
require_relative('tetromino')
require_relative('square_block')
require_relative('t_block')
require_relative('l_block')
require_relative('backward_l_block')
require_relative('s_block')
require_relative('z_block')
require_relative('line_block')
require_relative('board')
require_relative('artificial_intelligence')

# A TetrisWindow is the window the renders the concept
# of the Tetris game board as an image that the user can see.
# Gosu library information from:
# https://github.com/gosu/gosu/wiki/Ruby-Tutorial
class TetrisWindow < Gosu::Window
  # Width of screen in pixels
  SCREEN_WIDTH = 640
  # Height of screen in pixels
  SCREEN_HEIGHT = 480
  
  # Starting row for a new Tetromino
  START_ROW = 0
  # Starting column for a new Tetromino
  START_COL = 4
  
  # Flag for the game's AI mode, which is the default
  AI_MODE = 0
  # Flag for the game's user-controlled mode, which is for debugging.
  USER_MODE = 1
  
  # Index for the gravity moves in the move sequence array
  GRAVITY_MOVE = 0
  # Index for the rotation moves in the move sequence array
  ROTATION_MOVE = 1
  # Index for the horizontal moves in the move sequence array
  SIDEWAYS_MOVE = 2
  
  # Constructor
  # param mode is the game mode to use.  It will be AI_MODE unless
  # the program is in debug mode.
  def initialize(mode)
    @mode = mode
    # Make the game window (not full screen)
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = 'Tetris'
    @background_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/background.png"
      ),
      :tileable => true
    )
    
    # Tracks whether a button is pressed or not
    @button_down = false
    
    # Tracks whether we can move or not
    @can_move = true
    
    # Timer for gravity move
    @gravity_counter = 0;
    
    # Lines made so far
    @lines_made = 0
    
    # Current score
    @score = 0
    
    # The Tetris board
    @board = Board.new()
    # The current tetromino
    @tetromino = generateTetromino(START_ROW, START_COL)
    # Add the tetromino to the board
    @board.addTetromino(@tetromino)
    
    @move_sequence = generateAIMove()
  end
  
  # Update the board at every iteration of the game loop.
  def update()
    # Copy the tetromino so that we can back out of a bad move.
    previous_tetromino = DeepClone.clone(@tetromino)
    
    # Remove the tetromino from the board so that it doesn't get in the way.
    @board.removeTetromino(@tetromino)
  
    # Store validity of gravity move.  If the gravity move
    # wasn't valid, then we hit the bottom and the tetromino
    # should be placed on the board without doing any move logic.
    tetromino_placed = !gravityMove()
    unless (tetromino_placed)
      if (@mode == USER_MODE)
        tetromino_placed = doUserMove()
      else
        tetromino_placed = doAIMove()
      end
    end
    
    # The tetromino hit the bottom of the board or
    # the top of non-empty block, so this tetromino
    # can no longer be moved.
    if (tetromino_placed)
      # Handle a race-condition between gravity and user/AI downward moves
      # that makes the downward-moving tetromino stop short.
      placed_tetromino = DeepClone.clone(previous_tetromino)
      if (previous_tetromino.moveDown() and
          !@board.causesCollision?(previous_tetromino))
        placed_tetromino.moveDown()
      end
      # Add the previous Tetromino because it was the last valid
      # state for this Tetromino
      @board.addTetromino(placed_tetromino)
      lines_cleared = @board.clearLines()
      @lines_made += lines_cleared
      updateScore(lines_cleared)
      @tetromino = generateTetromino(START_ROW, START_COL)
      # If a tetromino is generated on top of an existing tetromino,
      # the game is over.  Print the number of lines made.
      if (@board.causesCollision?(@tetromino))
        abort("Game Over.  #{@lines_made} lines made; Score: #{@score}\n")
      end
      @board.addTetromino(@tetromino)
      @gravity_counter = 0
      
      # Generate the next AI move if the AI is playing.
      if (@mode == AI_MODE)
        @move_sequence = generateAIMove()
      end
    else
      # If a block movement for the tetromino was invalid,
      # put the old tetromino back.  In essence, cancel the move.
      if (!@can_move || @board.causesCollision?(@tetromino))
        @tetromino = previous_tetromino
      end
      
      # Update the board
      @board.addTetromino(@tetromino)
      
      # Update the gravity counter
      @gravity_counter += 1
    end
  end
  
  # Handles the game logic for a human user playing Tetris
  # return true if the Tetromino was placed, false otherwise
  def doUserMove()
    # @can_move will become false if we try to do an invalid move.
    @can_move = true
    
    # Keep user from overflowing the user input by holding a button down.    
    unless (buttonPressed())
      @button_down = false
    end
    
    # Let the user move the tetromino if a button isn't currently down
    # and gravity hasn't eliminated our ability to move.
    if (!@button_down)
      @can_move = userMoveSideways()
      if (@can_move)
        @can_move = userMoveRotate()
      end
      tetromino_placed = !userMoveDown()
    end
    
    return tetromino_placed
  end
  
  # Process for unpacking the generated move sequence into a
  # set of left, right, down, and rotate moves.  The AI will
  # do gravity moves incurred during its thinking time first, followed by
  # rotate moves, then move the tetromino left or right into place.
  # Once the move is completed, the AI will move the tetromino
  # downward until it falls into place.
  # return true if this move placed a tetromino and false
  # otherwise.
  def doAIMove()
    @can_move = true
    # Account for the gravity moves spent while thinking first
    # The tetromino might have been placed.
    if (@move_sequence[GRAVITY_MOVE] != 0)
      @move_sequence[GRAVITY_MOVE] -= 1
      return !moveDown()
    # Do the rotation before doing anything else
    # Tetromino definitely wasn't placed.
    elsif (@move_sequence[ROTATION_MOVE] != 0)
      if (@move_sequence[ROTATION_MOVE] == 3)
        @tetromino.rotateRight()
        @move_sequence[ROTATION_MOVE] = 0
      else
        @tetromino.rotateLeft()
        @move_sequence[ROTATION_MOVE] -= 1
      end
      return false
    # Move the tetromino into place laterally.  The
    # Tetromino definitely wasn't placed.
    elsif (@move_sequence[SIDEWAYS_MOVE] != 0)
      if (@move_sequence[SIDEWAYS_MOVE] < 0)
        @tetromino.moveLeft()
        @move_sequence[SIDEWAYS_MOVE] += 1
      else
        @tetromino.moveRight()
        @move_sequence[SIDEWAYS_MOVE] -= 1
      end
      return false
    # Drop it into position as quickly as possible
    else
      return !moveDown()
    end
  end
  
  # Generate the best move possible using the AI class.
  # return the sequence corresponding to the best move in
  # the format [gravity_moves, rotate_moves, sideways_moves, downward_moves]
  def generateAIMove()
    ai = ArtificialIntelligence.new(@board, @tetromino)
    move_sequence, elapsed_time = ai.getBestMove()
    gravity_moves_per_second = 60 / getGravityThreshold()
    gravity_moves = (elapsed_time / gravity_moves_per_second).floor()
    gravity_remainder = (elapsed_time.modulo(gravity_moves_per_second)).floor()
    @gravity_counter = getGravityThreshold() - gravity_remainder
    move_sequence.unshift(gravity_moves)
    return move_sequence
  end
  
  #Repaint the background and board on the screen.
  def draw()
    @background_image.draw(0, 0, 0)
    @board.draw()
  end
  
  # Randomly generates the next tetromino
  # param row is the starting row of the tetromino
  # param col is the starting column of the tetromino
  # return a randomly picked tetromino from the list of all
  # possible tetrominos.
  def generateTetromino(row, col)
    case (Random.rand(Tetromino::NUMBER_TETROMINOS) + 1)
    when Tetromino::SQUARE
      return SquareBlock.new(row, col)
    when Tetromino::LINE
      return LineBlock.new(row, col)
    when Tetromino::T
      return TBlock.new(row, col)
    when Tetromino::L
      return LBlock.new(row, col)
    when Tetromino::BACKWARD_L
      return BackwardLBlock.new(row, col)
    when Tetromino::Z
      return ZBlock.new(row, col)
    when Tetromino::S
      return SBlock.new(row, col)
    else
      abort('Invalid tetromino generated')
    end
  end
  
  # return true if any of the buttons used for controls
  # are being pressed and false otherwise.
  def buttonPressed()
    return (Gosu::button_down?(Gosu::KbLeft) or
            Gosu::button_down?(Gosu::KbRight) or
            Gosu::button_down?(Gosu::KbDown) or
            Gosu::button_down?(Gosu::GpLeft) or
            Gosu::button_down?(Gosu::GpRight) or
            Gosu::button_down?(Gosu::GpButton0) or
            Gosu::button_down?(Gosu::KbA) or
            Gosu::button_down?(Gosu::KbD))
  end
  
  # If gravity has taken over, do an automatic moveDown() and
  # reset the gravity counter
  # return true if the tetromino can still move and false otherwise.
  def gravityMove()
    if (@gravity_counter == getGravityThreshold())
      @gravity_counter = 0
      @can_move = false
      return moveDown()
    end
    return true
  end
  
  # Moves the current Tetromino left if the button
  # corresponding to a left move is pressed and right if
  # the button corresponding to a right move is pressed.
  # Side effect: takes note that a button has been pressed.
  # return true if the move is valid and false otherwise.
  def userMoveSideways()
    # Left movement
    if (Gosu::button_down?(Gosu::KbLeft) or 
        Gosu::button_down?(Gosu::GpLeft))
      @button_down = true
      return @tetromino.moveLeft()
    # Right movement
    elsif (Gosu::button_down?(Gosu::KbRight) or
        Gosu::button_down?(Gosu::GpRight))
      @button_down = true
      return @tetromino.moveRight()
    end
    
    # If there was no user input, the move is
    # still valid.
    return true
  end
  
  # Do a rotate move if the user is pressing the button that
  # corresponds to a rotate move.
  # return true if the move was valid and false otherwise
  def userMoveRotate()
    # Rotate left
    if (Gosu::button_down?(Gosu::KbA))
      @button_down = true
      return @tetromino.rotateLeft()
    #Rotate right
    elsif (Gosu::button_down?(Gosu::KbD))
      @button_down = true
      return @tetromino.rotateRight()
    end
    return true
  end
  
  # Moves the current Tetromino down if the button
  # corresponding to a downward move is pressed.
  # Side effect: takes note that a button has been pressed.
  # return true if the move is valid and false otherwise.
  def userMoveDown()
    if (Gosu::button_down?(Gosu::KbDown) or
        Gosu::button_down?(Gosu::GpButton0))
      @button_down = true
      return moveDown()
    end
    return true
  end
  
  # Handles moving a Tetromino while checking for a collision.
  # Used for downward moves for both gravity and user input.
  # return true if the move is valid and false otherwise.
  def moveDown()
    return (@tetromino.moveDown() && !@board.causesCollision?(@tetromino))
  end
  
  # Gravity threshold is calculated by using a starting threshold of 60,
  # which means that the current tetromino will move down once due to gravity
  # after 60 iterations of the game loop.  The gravity threshold is reduced by
  # 5 for every 10 lines made, but it will never be less than 10.
  # return the number of iterations of the game loop that occur before
  # the current Tetromino moves down once due to gravity.
  def getGravityThreshold()
    return [5, 40 - 2 * getLevel()].max()
  end
  
  # return the current "level" of the game, which is the truncated
  # result of dividing the number of lines made so far by 10.
  def getLevel()
    return (@lines_made / 10).floor()
  end
  
  # Update the score based on the standard Tetris scoring system, which
  # multiplies a scoring factor by the current level plus 1 (level 0 is first)
  # Scoring factors are:
  #   40 for 1 line
  #   100 for 2 lines
  #   300 for 3 lines
  #   1200 for 4 lines (a Tetris)
  def updateScore(lines_cleared)
    score_factor = 0
    case (lines_cleared)
    when 1
      score_factor = 40
    when 2
      score_factor = 100
    when 3
      score_factor = 300
    when 4
      score_factor = 1200
    else
      score_factor = 0
    end
    
    @score += score_factor * (getLevel() + 1)
  end
end