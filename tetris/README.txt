Kevin Dittmar
1 December 2015
Artificial Intelligence Project:  Tetris

This project contains a fully-functioning Tetris game that can be played
by a human player or an AI player.  To start up the game with an AI player,
the following command or an equivalent should be used:
    ruby main.rb
To start up the game with a human player, the following command should be
used:
    ruby main.rb --debug
The Tetris AI uses a state-based heuristic-driven search to choose its moves.
As of 12/1/15, its best observed score has been 235,900 (300 lines).
The most lines that it has ever formed in a game was 381 lines.  Unfortunately,
381 lines were formed by an earlier version of the game before the scoring
system was implemented, so there is no observed score for that run.

Project contents:

This directory:
    src:                The directory where the code, assets, and tests for
                        the Tetris project are stored.
    Gemfile:            A list of Ruby gems (mini libraries) used by the
                        Tetris project
    Gemfile.lock:       A locked version of Gemfile auto-generated when
                        bundling gems
    README.txt:         This file

src directory:
    doc:        The directory containing RDoc documentation for the source
                code.
    lib:        The directory containing all source code files and image
                assets.
    spec:       The directory containing all RSpec tests
    main.rb:    The main driver for the Tetris project

doc directory:
    images:     The directory containing images used by RDoc
    js:         The directory containing JavaScript used by RDoc
    ArtificialIntelligence.html:    RDoc for the AI class
    BackwardLBlock.html:            RDoc for the BackwardLBlock class
    Block.html:                     RDoc for the Block class
    Board.html:                     RDoc for the Board class
    created.rid:                    An ID file used by RDoc
    index.html:                     An index page for RDoc
    LBlock.html:                    RDoc for the LBlock class
    LineBlock.html:                 RDoc for the LineBlock class
    Object.html:                    RDoc for helper functions in the test
                                    files.  The RDoc generator put them here.
    rdoc.css:                       CSS for the RDoc files
    SBlock.html:                    RDoc for the SBlock class
    SquareBlock.html:               RDoc for the SquareBlock class
    table_of_contents.html:         A table of contents page for RDoc
    TBlock.html:                    RDoc for the TBlock class
    TetrisWindow.html:              RDoc for the TetrisWindow class
    Tetromino.html:                 RDoc for the Tetromino class
    ZBlock.html:                    RDoc for the ZBlock class
lib directory:
    assets:                     The directory that contains all images used
                                for rendering the Tetris board
    artificial_intelligence.rb: The class for the AI that plays Tetris.  It
                                includes the heuristics and selects the best
                                move given a board state and a tetromino.
    backward_l_block.rb:        The class for a backward L-block tetromino
    block.rb:                   The class for a block, which is a single cell
                                on the board.
    board.rb:                   The class for the representation of the game
                                board.
    l_block.rb:                 The class for an L-block tetromino.
    line_block.rb:              The class for a line block tetromino.
    s_block.rb:                 The class for an S-block tetromino.
    square_block.rb:            The class for a square block (sometimes
                                called an O-block) tetromino.
    t_block.rb                  The class for a T-block tetromino.
    tetris_window.rb            The class that handles drawing the current
                                state of the Tetris game on the screen.
    tetromino.rb                The superclass for all tetromino classes.
    z_block.rb                  The class for a Z-block tetromino.
    
spec directory:
    artificial_intelligence_spec.rb:    RSpec tests for the AI's testable
                                        heuristics.
    board_spec.rb:                      The file that contains some basic
                                        RSpec tests for the Board class.
    tetromino_spec.rb:                  RSpec tests that ensure that all game
                                        moves work as intended for all of the
                                        different tetrominoes.
assets directory:
    background.png:     The background image for the game screen.
    beige_block.bmp:    The image for line block tetromino blocks.
    black_block.bmp:    The image for square block tetromino blocks.
    dark_red_block.bmp: The image for L-block tetromino blocks.
    empty_block.bmp:    The image for unfilled blocks on the Tetris game
                        board.
    green_block.bmp:    The image for backward L-block tetromino blocks.
    orange_block.bmp:   The image for S-block tetromino blocks.
    red_block.bmp:      The image for Z-block tetromino blocks.
    yellow_block.bmp:   The image for T-block tetromino blocks.