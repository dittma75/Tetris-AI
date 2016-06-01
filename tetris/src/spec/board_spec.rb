# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

require('board')
require('gosu')
require('tetromino')
require('tetris_window')

# Tests relating to board integrity.
describe Board do
    before(:each) do
      @board = Board.new()
    end
    
    it 'should have the right number of rows' do
      expect(@board.getBoard().count()).to eq(Board::ROWS)
    end
    
    it 'should have the right number of columns' do
      @board.getBoard().each do |row|
        expect(row.count()).to eq (Board::COLUMNS)
      end
    end
    
    it 'should be an empty board on initialization' do
      @board.getBoard().flatten.each do |cell|
        expect(cell).to eq(0)
      end
    end
end
