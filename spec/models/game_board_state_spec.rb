require 'rails_helper'

RSpec.describe GameBoardState, type: :model do
  let(:user) { create(:user) }

  describe 'associations' do
    it 'belongs to a user' do
      game = build(:game_board_state, user: user)
      expect(game.user).to eq(user)
    end
  end

  describe 'validations' do
    context 'with valid attributes' do
      let(:game) { create(:game_board_state, user: user)}
      it 'is valid' do
        expect(game).to be_valid
      end
    end

    describe 'with invalid attributes' do
      context 'with invalid rows' do
        it 'is invalid if rows less than 1' do
          invalid_game = build(:game_board_state, user: user, rows: 0, cols: 10)
          expect(invalid_game).not_to be_valid
        end

        it 'is invalid if row greater than 50' do
          invalid_game = build(:game_board_state, user: user, rows: 52, cols: 10)
          expect(invalid_game).not_to be_valid
        end
      end

      context 'with invalid cols' do
        it 'is invalid if cols less than 1' do
          invalid_game = GameBoardState.new(user: user, rows: 10, cols: 0)
          expect(invalid_game).not_to be_valid
        end

        it 'is invalid if cols greater than 50' do
          invalid_game = GameBoardState.new(user: user, rows: 10, cols: 51)
          expect(invalid_game).not_to be_valid
        end
      end
    end
  end
end
