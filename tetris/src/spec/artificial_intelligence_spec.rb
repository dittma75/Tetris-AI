# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

require('board')
require('tetromino')
require('l_block')
require('square_block')
require('artificial_intelligence')

# Tests that ensure proper functioning of some AI heuristics.
describe ArtificialIntelligence do
  before(:each) do
    @board = Board.new()
    @tetromino = SquareBlock.new(4, 4)
    @ai = ArtificialIntelligence.new(@board, @tetromino)
  end
  
  # Tests the heuristic that counts the holes beneath a tetromino.
  it 'should count holes under Tetrominoes and calculate 
      the heuristic correctly' do
    tetromino = LBlock.new(4, 4)
    tetromino = placeTetrominoLeft(tetromino)
    expect(@ai.getHolesBelowTetromino(tetromino)).to eq(-1600)
  end
  
  # Test the heuristic that counts tetromino blocks within the reward zone
  it 'should count all tetromino blocks in heuristic if tetromino is
      within reward zone' do
    line_block = LineBlock.new(4, 4)
    line_block.rotateLeft()
    @board.addTetromino(placeTetrominoRight(line_block))
    tetromino = BackwardLBlock.new(4, 4)
    tetromino = placeTetrominoLeft(tetromino)
    
    ai = ArtificialIntelligence.new(@board, tetromino)
    expect(ai.getBlocksInRewardZone(tetromino)).to eq(20)
  end
  
  # Test the heuristic for blocks within the reward zone where only part
  # of the tetromino is in the reward zone.
  it 'should use tetromino blocks below the reward zone top in heuristic' do
    @board.addTetromino(placeTetrominoRight(LBlock.new(4, 4)))
    tetromino = LineBlock.new(4, 4)
    tetromino.rotateLeft()
    tetromino = placeTetrominoLeft(tetromino)
    
    ai = ArtificialIntelligence.new(@board, tetromino)
    expect(ai.getBlocksInRewardZone(tetromino)).to eq(10)
  end
end

# Helper function to place the tetromino on the left side of the board
# param tetromino is the tetromino to place
# return the tetromino placed as far left as possible on the board
def placeTetrominoLeft(tetromino)
    previous_tet = DeepClone.clone(tetromino)
    while (tetromino.moveLeft())
      previous_tet.moveLeft()
    end
    tetromino = previous_tet

    return placeTetromino(tetromino)
end

# Helper function to place the tetromino on the right side of the board
# param tetromino is the tetromino to place
# return the tetromino placed as far right as possible on the board
def placeTetrominoRight(tetromino)
  previous_tet = DeepClone.clone(tetromino)
  while (tetromino.moveRight())
    previous_tet.moveRight()
  end
  tetromino = previous_tet
  
  return placeTetromino(tetromino)
end

# Helper function to place the tetromino at the bototm of the board
# param tetromino is the tetromino to place
# return the tetromino placed as far down as possible on the board
def placeTetromino(tetromino)
  previous_tet = DeepClone.clone(tetromino)
  while (tetromino.moveDown())
    previous_tet.moveDown()
  end
  tetromino = previous_tet
  
  return tetromino
end