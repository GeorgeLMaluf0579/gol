class CreateGameBoardStates < ActiveRecord::Migration[7.2]
  def change
    create_table :game_board_states do |t|
      t.integer :generation
      t.integer :rows
      t.integer :cols
      t.jsonb :first_state
      t.jsonb :current_state
      t.references :user, null: false, foreign_key: true

      t.check_constraint 'rows BETWEEN 1 AND 50', name: 'row_size_check'
      t.check_constraint 'cols BETWEEN 1 AND 50', name: 'col_size_check'

      t.timestamps
    end
  end
end
