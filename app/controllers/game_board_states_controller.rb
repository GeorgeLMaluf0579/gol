class GameBoardStatesController < ApplicationController
  before_action :set_game_board_state, only: %i[show destroy reset new_generation]

  def index
    @game_boards = current_user.game_board_states.order(updated_at: :desc)
  end

  def new
    @game_board_state = GameBoardState.new
  end

  def show; end

  def create
    @game_board_state = current_user.game_board_states.new(game_board_state_params)
    return handle_error(@game_board_state) unless @game_board_state.save

    handle_success(@game_board_state)
  end

  def new_generation
    @game_board_state.new_generation!
    flash.now[:notice] = "Generation #{@game_board_state.generation} calculated"
    render :update_game_board_state, formats: :turbo_stream
  end

  def reset
    unless @game_board_state.reset!
      flash.now[:alert] = "Could not restore the initial generation"
      return render :update_game_board_state, format: :turbo_stream
    end
    flash.now[:notice] = "Initial generation restored"
    render :update_game_board_state, format: :turbo_stream
  end

  def destroy
    @game_board_state.destroy
    flash[:notice] = "GameBoard deleted!"
    redirect_to game_board_states_path
  end

  private

  def game_board_state_params
    params.require(:game_board_state).permit(:input_file)
  end

  def set_game_board_state
    @game_board_state = current_user.game_board_states.find(params[:id])
  end

  def handle_success(game_board_state)
    flash[:notice] = "Game board create successfully"
    redirect_to game_board_states_path
  end

  def handle_error(game_board_state)
    flash[:alert] = "Error saving the game board: #{game_board_state.errors.full_messages.join(', ')}"
    redirect_to new_game_board_state_path
  end
end
