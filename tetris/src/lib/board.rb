# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

require_relative('block')

# A Board is the data structure that holds
# the value of all rows and columns needed
# to keep track of the state of the Tetris board.

class Board
  # A board has 22 rows
  ROWS = 22
  # A board has 10 columns
  COLUMNS = 10
  
  # Constructor
  def initialize()
    @block_images = loadResources()
    
    # Abort if the board is too wide for the screen.
    @board_width = COLUMNS * Block::BLOCK_WIDTH
    if (@board_width > TetrisWindow::SCREEN_WIDTH)
      abort('Board too wide for screen')
    end
    
    # Abort if the board is too tall for the screen.
    @board_height = ROWS * Block::BLOCK_HEIGHT
    if (@board_height > TetrisWindow::SCREEN_HEIGHT)
      abort('Board too tall for screen')
    end
    
    # Board is positioned horizontally in the center of the screen
    @board_start_x = (TetrisWindow::SCREEN_WIDTH - @board_width) / 2
    
    # Board is positioned vertically at the bottom of the screen
    @board_start_y = TetrisWindow::SCREEN_HEIGHT - @board_height
    
    # Start the board off empty.
    @board = []
    ROWS.times do
      @board.push(emptyLine())
    end
  end
  
  # param row is the row to test for line status
  # return true if the given row is a line, false otherwise.
  def isLine?(row)
    return !row.include?(0)
  end
  
  # Remove the specified row from the Board and
  # add an empty line to the top row of the Board.
  # param row_index is the index of the row in the Board to remove.
  def removeLine(row_index)
    @board.delete_at(row_index)
    @board.unshift(emptyLine())
  end

  # Removes cleared lines from the board
  # @return the number of lines cleared
  def clearLines()
    lines_cleared = 0
    for row_index in 0...ROWS
      if (isLine?(@board[row_index]))
        removeLine(row_index)
        lines_cleared += 1
      end
    end
    return lines_cleared
  end
  
  # return the representation of the Tetris Board.
  def getBoard()
    return @board
  end
  
  # return an empty line, which is an array that has
  # a number of 0s equal to the number of columns in
  # the game board.
  def emptyLine()
    return Array.new(COLUMNS, Tetromino::EMPTY);
  end
  
  # Draw every block of the game board with the appropriately
  # colored cell based on whether each block is empty or
  # occupied.  Occupied blocks are the color of the tetromino
  # to which they belong.
  def draw()
    for row in 0...ROWS
      for col in 0...COLUMNS
        y = @board_start_y + row * Block::BLOCK_WIDTH
        x = @board_start_x + col * Block::BLOCK_HEIGHT
        @block_images[@board[row][col]].draw(x, y, 1)
      end
    end
  end
  
  # return the left boundary of the Board
  def getLeftBound()
    return @board_start_x
  end
  
  # return the right boundary of the Board
  def getRightBound()
    return @board_start_x + @board_width
  end
  
  # return the top boundary of the Board
  def getTopBound()
    return @board_start_y
  end
  
  # return the bottom boundary of the Board
  def getBottomBound()
    return @board_start_y + @board_height
  end
  
  # Add a tetromino's blocks to the Board by setting
  # each (row, column) pair on the Board that corresponds
  # to a block of this tetromino to be the number that
  # corresponds to that tetromino's type.
  # param tetromino is the Tetromino to add to the Board
  def addTetromino(tetromino)
    # Set every board space that this Tetromino occupies to type number.
    tetromino.getBlocks().each do |block|
      @board[block.getRow()][block.getColumn()] = tetromino.getType()
    end
  end
  
  # Set each block on the Board that corresponds to a block
  # in the tetromino to be the number that corresponds to a
  # block representing empty space on the Board.
  # param tetromino is the Tetromino to remove from the Board
  def removeTetromino(tetromino)
    # Set every board space that this Tetromino occupies to an empty block.
    tetromino.getBlocks().each do |block|
      @board[block.getRow()][block.getColumn()] = Tetromino::EMPTY
    end
  end
  
  # param tetromino is the Tetromino that may be causing a collision
  # with Blocks from a Tetromino that has already been placed.
  # return true if there is a collision and false otherwise
  def causesCollision?(tetromino)
    # Check every block of this Tetromino for a collision
    tetromino.getBlocks().each do |block|
      if (@board[block.getRow()][block.getColumn()] != Tetromino::EMPTY)
        return true
      end
    end
    return false
  end
  
  # param index is the number of the row on the Board
  # return an array representing the specified row on the Board.
  def getRow(index)
    return @board[index]
  end
  
  # param row_index is the row from which to start considering the column.
  # param index is the column index.
  # return a partial column from row_index to the bottom of the board.
  def getColumnBelowRow(row_index, col_index)
    column = Array.new()
    # row_index is incremented because we want to look at the blocks below
    # the given row.  Lower rows have higher indices.
    for r in (row_index + 1)...Board::ROWS
      column.push(@board[r][col_index])
    end
    return column
  end
  
  # Get the images to be used to render the board.
  # return @block_images, the array of images where the
  # index corresponds to the enum for Tetromino type, and
  # the value of each index is the image to use for that
  # Tetromino type.
  def loadResources()
    empty_image = Gosu::Image.new(
        File.join(
            File.dirname(__FILE__), 
            "assets/empty_block.bmp"
        )
    )
    
    square_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/black_block.bmp"
      )
    )
    
    line_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/beige_block.bmp"
      )
    )
    
    t_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/yellow_block.bmp"
      )
    )
    
    l_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/dark_red_block.bmp"
      )
    )
    
    backward_l_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/green_block.bmp"
      )
    )

    s_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/orange_block.bmp"
      )
    )
    
    z_image = Gosu::Image.new(
      File.join(
        File.dirname(__FILE__), 
        "assets/red_block.bmp"
      )
    )
    
    # Store the image for each Block in the array index
    # that matches the type of the Block.
    block_images = Array.new()
    block_images[Tetromino::EMPTY] = empty_image
    block_images[Tetromino::SQUARE] = square_image
    block_images[Tetromino::LINE] = line_image
    block_images[Tetromino::T] = t_image
    block_images[Tetromino::L] = l_image
    block_images[Tetromino::BACKWARD_L] = backward_l_image
    block_images[Tetromino::S] = s_image
    block_images[Tetromino::Z] = z_image
    
    return block_images
  end
end