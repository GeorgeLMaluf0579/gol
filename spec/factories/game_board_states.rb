FactoryBot.define do
  factory :game_board_state do
    association :user
    generation { 1 }
    rows { 10 }
    cols { 10 }
    current_state { Array.new(rows) { Array.new(cols, '.') } }
    initial_state { {} }
  end
end
