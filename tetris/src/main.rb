# Kevin Dittmar
# 1 December 2015
# Artificial Intelligence Project:  Tetris

# main.rb is a simple driver to start the Tetris program
require_relative('lib/tetris_window')

mode = TetrisWindow::AI_MODE

# Check for debug mode flag.  Otherwise, use AI mode.
if (ARGV.count() > 0 and ARGV[0].eql?('--debug'))
  mode = TetrisWindow::USER_MODE
end
# Start the program by making a new game window and showing it.
window = TetrisWindow.new(mode)
window.show