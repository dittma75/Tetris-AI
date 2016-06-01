# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

require('board')
require('square_block')
require('l_block')
require('backward_l_block')
require('t_block')
require('s_block')
require('z_block')
require('line_block')

# Tests that ensure the integrity of all tetromino moves
describe Tetromino do
  ['SquareBlock', 'LBlock', 'BackwardLBlock', 'TBlock',
   'SBlock', 'ZBlock', 'LineBlock'].each do |tet_type|
    # Tests that validate all moves for the current tetromino
    # whose type is tet_type
    describe Module.const_get(tet_type) do
      before(:each) do
        row = Board::ROWS / 2
        col = Board::COLUMNS / 2
        @src_tet = Module.const_get(tet_type).new(row, col)
        @dest_tet = DeepClone.clone(@src_tet)
        @board = Board.new()
      end
      
      # Tests moveLeft() move
      it "should have all of its blocks shifted left 1 after moveLeft" do
        isValid = @dest_tet.moveLeft()
        expect(isValid).to eq(true)
        @board.addTetromino(@dest_tet)
        checkTetOnBoard(@dest_tet, @board)
        for i in 0...@dest_tet.getBlocks().count()
          expect(@dest_tet.getBlocks()[i].getColumn())
            .to eq(@src_tet.getBlocks()[i].getColumn() - 1)
        end
      end
      
      # Tests moveRight() move
      it "should have all of its blocks shifted right 1 after moveRight" do
        isValid = @dest_tet.moveRight()
        expect(isValid).to eq(true)
        @board.addTetromino(@dest_tet)
        checkTetOnBoard(@dest_tet, @board)
        for i in 0...@dest_tet.getBlocks().count()
          expect(@dest_tet.getBlocks()[i].getColumn())
            .to eq(@src_tet.getBlocks()[i].getColumn() + 1)
        end
      end
      
      # Tests moveLeft() move
      it "should have all of its blocks shifted down 1 after moveDown" do
        isValid = @dest_tet.moveDown()
        expect(isValid).to eq(true)
        @board.addTetromino(@dest_tet)
        checkTetOnBoard(@dest_tet, @board)
        for i in 0...@dest_tet.getBlocks().count()
          expect(@dest_tet.getBlocks()[i].getRow())
            .to eq(@src_tet.getBlocks()[i].getRow() + 1)
        end
      end
      
      # Tests left board boundary
      it "should not allow Tetrominoes to be moved left off of the board" do
        src_tet = Module.const_get(tet_type).new(Board::ROWS / 2, 0)
        dest_tet = DeepClone.clone(src_tet)
        isValid = dest_tet.moveLeft()
        expect(isValid).to eq(false)
        for i in 0...dest_tet.getBlocks().count()
          expect(dest_tet.getBlocks()[i].getColumn())
            .to eq(src_tet.getBlocks()[i].getColumn())
        end
      end
      
      # Tests right board boundary
      it "should not allow Tetrominoes to be moved right off of the board" do
        src_tet = Module.const_get(tet_type).new(Board::ROWS / 2, Board::COLUMNS)
        dest_tet = DeepClone.clone(src_tet)
        isValid = dest_tet.moveRight()
        expect(isValid).to eq(false)
        for i in 0...dest_tet.getBlocks().count()
          expect(dest_tet.getBlocks()[i].getColumn())
            .to eq(src_tet.getBlocks()[i].getColumn())
        end
      end
      
      # Tests bottom board boundary
      it "should not allow Tetrominoes to be moved down off of the board" do
        src_tet = Module.const_get(tet_type).new(Board::ROWS, Board::COLUMNS / 2)
        dest_tet = DeepClone.clone(src_tet)
        isValid = dest_tet.moveDown()
        expect(isValid).to eq(false)
        for i in 0...dest_tet.getBlocks().count()
          expect(dest_tet.getBlocks()[i].getColumn())
            .to eq(src_tet.getBlocks()[i].getColumn())
        end
      end
      
      # Tests rotation moves
      it "should rotate properly" do
        rot_left_tet = DeepClone.clone(@dest_tet)
        rot_right_tet = DeepClone.clone(@dest_tet)
        
        # Check that 90 degrees clockwise is the same as
        # 270 degrees counter-clockwise.
        rot_left_tet.rotateLeft()
        rot_right_tet.rotateRight()
        rot_right_tet.rotateRight()
        rot_right_tet.rotateRight()
        rotate_compare(rot_left_tet, rot_right_tet)
        
        # Check the next three 90 degree turns.
        3.times.each do
          rot_left_tet.rotateLeft()
          rot_right_tet.rotateLeft()
          rotate_compare(rot_left_tet, rot_right_tet)
        end
      end
    end
  end
end

# Rotate comparison helper function.  Both tetrominoes should
# have blocks in equivalent positions.
# param tet1 is the first tetromino to compare
# param tet2 is the second tetromino to compare
def rotate_compare(tet1, tet2)
  for i in 0...tet1.getBlocks().count()
    expect(tet1.getBlocks()[i].getColumn())
      .to eq(tet2.getBlocks()[i].getColumn())
    expect(tet1.getBlocks()[i].getRow())
      .to eq(tet2.getBlocks()[i].getRow())
  end
end

# Check that the tetromino is actually on the board
# param tet is the tetromino that should be on the board
# param board is the board state
def checkTetOnBoard(tet, board)
  tet.getBlocks().each do |block|
    expect(board.getBoard()[block.getRow()][block.getColumn()]).to eq(tet.getType())
  end
end