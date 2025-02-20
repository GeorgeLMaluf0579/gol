class GameBoardFileParserService
  def initialize(raw_data)
    @raw_data = raw_data
    @lines = []
    @rows = nil
    @col = nil
  end

  def call
    parse_file
    {
      generation: @generation,
      rows: @rows,
      cols: @cols,
      current_state: parse_grid_data
    }
  end

  def parse_file
    @lines = @raw_data.lines.map(&:strip).reject(&:empty?)
    raise "File is empty or invalid" if @lines.empty?

    parse_generations
    parse_board_dimensions
  end

  def parse_generations
    unless @lines.first =~ /^Generation\s+(\d+):\s*$/
      raise 'Missing or malformated generation line'
    end
    @generation = $1.to_i
    @lines.shift
  end


  def parse_board_dimensions
    unless @lines.first =~ /^(\d+)\s+(\d+)$/
      raise 'Missing or malformated dimensions line'
    end
    @rows, @cols = @lines.shift.split.map(&:to_i)
  end


  def parse_grid_data
    grid = @lines.map { |line| line.chars }
    validate_grid(grid)
    grid
  end

  def validate_grid(grid)
    unless grid.size == @rows && grid.all? { |row| row.size == @cols } 
      raise 'Grid dimensions not match with the specified rows and columns'
    end
  end
end
