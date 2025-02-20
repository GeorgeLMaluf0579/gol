class GameBoardState < ApplicationRecord
  belongs_to :user

  validates :rows, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
  validates :cols, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50 }
end
