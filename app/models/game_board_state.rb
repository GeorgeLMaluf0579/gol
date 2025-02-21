class GameBoardState < ApplicationRecord
  belongs_to :user

  attr_accessor :input_file

  validates :rows, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :cols, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }

  before_validation :read_file if :input_file
  before_create :store_first_state
  before_save :update_population_count

  def new_generation!
    begin
      GameBoardGeneratorService.new(self).next_generation!
      true
    rescue StandardError => ex
      errors.add(:base, ex.message)
      false
    end
  end

  def reset!
    return false if first_state.blank?
    self.generation = first_state["generation"]
    self.rows = first_state["rows"]
    self.cols = first_state["cols"]
    self.current_state = first_state["current_state"]
    save
  end

  private

  def read_file
    if self.input_file.present?
      check_file_type
      parsed_attributes = GameBoardFileParserService.new(input_file.read).call
      self.attributes = parsed_attributes
    end
  rescue => e
    errors.add(:base, "Invalid file format: #{e.message}")
  end

  def check_file_type
    unless input_file.content_type == "text/plain"
      errors.add(:input_file, "must be a text (.txt) file")
      throw :abort
    end
  end

  def store_first_state
    self.first_state = {
      generation: generation,
      rows: rows,
      cols: cols,
      current_state: current_state
    }
  end

  def update_population_count
    self.population_count = current_state.flatten.count { |cell| cell == "*" }
  end
end
