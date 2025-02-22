require 'rails_helper'

RSpec.describe "GameBoardStates", type: :request do
  let(:user) { create(:user) }
  let(:game_board) { create(:game_board_state, user: user) }

  before do
    sign_in(user, scope: :user)
  end

  describe "GET /index" do
    it 'return the game board list' do
      get game_board_states_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it 'return the game board details' do
      get game_board_state_path(game_board)
    expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "renders the form for a new game board" do
      get new_game_board_state_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    context "with valid input file" do
      it "creates a new game board" do
        valid_file = fixture_file_upload('spec/fixtures/files/board_valid.txt', 'text/plain')
        expect {
          post game_board_states_path, params: { game_board_state: { input_file: valid_file } }
        }.to change(GameBoardState, :count).by(1)
        expect(response).to redirect_to(game_board_states_path)
      end
    end

    context "with invalid input file" do
      it "renders an error message and redirects" do
        invalid_file = fixture_file_upload('spec/fixtures/files/board_invalid_format.pdf', 'application/pdf')

        expect {
          post game_board_states_path, params: { game_board_state: { input_file: invalid_file } }
        }.not_to change(GameBoardState, :count)

        expect(response).to redirect_to(new_game_board_state_path)
        follow_redirect!
        expect(response.body).to include("Error saving the game board:")
      end
    end
  end

  describe "PATCH /new_generition" do
    it "progresses the game board state to the next generation" do
      mocked_game_state = instance_double("GameBoardState")

      allow(GameBoardState).to receive(:find).and_return(mocked_game_state)
      allow(mocked_game_state).to receive(:new_generation!).and_return(true)

      patch new_generation_game_board_state_path(game_board), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /reset" do
    context "when reset is successful" do
      it "resets the game board and renders turbo stream" do
        allow_any_instance_of(GameBoardState).to receive(:reset!).and_return(true)

        patch reset_game_board_state_path(game_board), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
      end
    end

    context "when reset fails" do
      it "shows an error message" do
        allow_any_instance_of(GameBoardState).to receive(:reset!).and_return(false)

        patch reset_game_board_state_path(game_board), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "DELETE /destroy" do
    it "deletes the game board and redirects to game board list" do
      delete game_board_state_path(game_board)
      expect(response).to have_http_status(302)

      expect(response).to redirect_to(game_board_states_path)
    end
  end
     
end
