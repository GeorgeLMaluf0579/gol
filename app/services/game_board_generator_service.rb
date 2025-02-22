class GameBoardGeneratorService
  LIVE = "*".freeze
  DEAD = ".".freeze

  NEIGHBOR_OFFSETS = [
    [ -1, -1 ], [ -1, 0 ], [ -1, 1 ],
    [ 0, -1 ],          [ 0, 1 ],
    [ 1, -1 ], [ 1, 0 ], [ 1, 1 ]
  ].freeze

  def initialize(game_board_state)
    @game_board_state = game_board_state
    @rows = game_board_state.rows
    @cols = game_board_state.cols
    @current_state = game_board_state.current_state
  end

  def next_generation!
    validate_current_state!

    next_state = Array.new(@rows) { Array.new(@cols, DEAD) }

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        is_currently_alive = @current_state[row][col] == LIVE
        neighbors = count_live_neighbors(row, col)

        next_state[row][col] = evaluate_next_cell_state(is_currently_alive, neighbors)
      end
    end

    GameBoardState.transaction do
      @game_board_state.current_state = next_state
      @game_board_state.generation += 1
      @game_board_state.save!
    end

  rescue ActiveRecord::RecordInvalid => e
    raise GameBoardGeneratorError, "Failed to save the game board state: #{e.record.errors.full_messages.join(', ')}"
  rescue StandardError => e
    raise GameBoardGeneratorError, "Error while progressing to the next generation: #{e.message}"
  end

  private

  def count_live_neighbors(row, col)
    NEIGHBOR_OFFSETS.count do |row_offset, col_offset|
      valid_position?(row + row_offset, col + col_offset) &&
        @current_state[row + row_offset][col + col_offset] == LIVE
    end
  end

  def evaluate_next_cell_state(is_alive, neighbors)
    return LIVE if is_alive && [ 2, 3 ].include?(neighbors)
    return LIVE if !is_alive && neighbors == 3

    DEAD
  end

  def valid_position?(row, col)
    row.between?(0, @rows - 1) && col.between?(0, @cols - 1)
  end

  def validate_current_state!
    unless @current_state.is_a?(Array) && @current_state.size == @rows
      raise GameBoardGeneratorError, "The number of rows does not match the expected #{@rows}"
    end

    @current_state.each_with_index do |row_array, i|
      unless row_array.is_a?(Array) && row_array.size == @cols
        raise GameBoardGeneratorError, "Row #{i} does not match the expected #{@cols} columns"
      end

      row_array.each_with_index do |cell, j|
        unless [ LIVE, DEAD ].include?(cell)
          raise GameBoardGeneratorError, "Invalid cell at position (#{i},#{j}): #{cell.inspect}"
        end
      end
    end
  end
end
