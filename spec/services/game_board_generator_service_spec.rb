require 'rails_helper'

RSpec.describe GameBoardGeneratorService do
  let(:user) { build(:user) }

  describe "Game of Life progression" do
    context "Rule 1: Any live cell with fewer than two live neighbours dies (underpopulation)" do
      it "kills a live cell with no live neighbours" do
        game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
          [ ".", ".", "." ],
          [ ".", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_board_state).to receive(:save!).and_return(true)

        GameBoardGeneratorService.new(game_board_state).next_generation!

        expect(game_board_state.generation).to eq(2)
        expect(game_board_state.current_state).to eq([
          [ ".", ".", "." ],
          [ ".", ".", "." ],
          [ ".", ".", "." ]
        ])
      end
    end

    context "Rule 2: Any live cell with two or three live neighbours survives" do
      it "keeps a live cell alive with two live neighbours" do
        game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
          [ ".", "*", "." ],
          [ "*", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_board_state).to receive(:save!).and_return(true)

        GameBoardGeneratorService.new(game_board_state).next_generation!

        expect(game_board_state.generation).to eq(2)
        expect(game_board_state.current_state[1][1]).to eq("*")
      end

      it "keeps a live cell alive with three live neighbours" do
        game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
          [ "*", "*", "." ],
          [ ".", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_board_state).to receive(:save!).and_return(true)

        GameBoardGeneratorService.new(game_board_state).next_generation!

        expect(game_board_state.generation).to eq(2)
        expect(game_board_state.current_state[1][1]).to eq("*")
      end
    end

    context "Rule 3: Any live cell with more than three live neighbours dies (overpopulation)" do
      it "kills a live cell with four live neighbours" do
        game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
          [ "*", "*", "*" ],
          [ "*", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_board_state).to receive(:save!).and_return(true)

        GameBoardGeneratorService.new(game_board_state).next_generation!

        expect(game_board_state.generation).to eq(2)
        expect(game_board_state.current_state[1][1]).to eq(".")
      end
    end

    context "Rule 4: Any dead cell with exactly three live neighbours becomes a live cell (reproduction)" do
      it "creates a new live cell if it has exactly three live neighbours" do
        game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
          [ ".", "*", "." ],
          [ ".", "*", "." ],
          [ ".", "*", "." ]
        ])

        allow(game_board_state).to receive(:save!).and_return(true)

        GameBoardGeneratorService.new(game_board_state).next_generation!

        expect(game_board_state.generation).to eq(2)
        expect(game_board_state.current_state).to eq([
          [ ".", ".", "." ],
          [ "*", "*", "*" ],
          [ ".", ".", "." ]
        ])
      end
    end
  end

  describe "Validation and error handling" do
    it "raises an error when the row count is incorrect" do
      game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
        [ ".", ".", "." ],
        [ ".", "*", "." ]  # Missing third row
      ])

      service = GameBoardGeneratorService.new(game_board_state)
      expect { service.next_generation! }
        .to raise_error(GameBoardGeneratorError, /number of rows/)
    end

    it "raises an error when a row has an incorrect column count" do
      game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
        [ ".", ".", "." ],
        [ ".", "*" ],  # Invalid row (only 2 columns instead of 3)
        [ ".", ".", "." ]
      ])

      service = GameBoardGeneratorService.new(game_board_state)
      expect { service.next_generation! }
      .to raise_error(GameBoardGeneratorError, /Row 1 does not match the expected \d+ columns/)
    end

    it "raises an error when an invalid character is present in the grid" do
      game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
        [ ".", ".", "." ],
        [ ".", "X", "." ],  # Invalid character "X"
        [ ".", ".", "." ]
      ])

      service = GameBoardGeneratorService.new(game_board_state)
      expect { service.next_generation! }
        .to raise_error(GameBoardGeneratorError, /Invalid cell/)
    end

    it "raises an error when saving the game state fails" do
      game_board_state = build(:game_board_state, user: user, rows: 3, cols: 3, current_state: [
        [ ".", "*", "." ],
        [ "*", "*", "." ],
        [ ".", ".", "." ]
      ])

      # Simulates a database validation failure
      allow(game_board_state).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(game_board_state))

      service = GameBoardGeneratorService.new(game_board_state)
      expect { service.next_generation! }
        .to raise_error(GameBoardGeneratorError, /Failed to save/)
    end
  end
end
