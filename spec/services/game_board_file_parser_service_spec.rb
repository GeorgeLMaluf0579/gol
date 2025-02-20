require 'rails_helper'


RSpec.describe GameBoardFileParserService do
  let(:valid_file) { fixture_file_upload('spec/fixtures/files/board_valid.txt', 'text/plain').read  } 
  let(:empty_file) { fixture_file_upload('spec/fixtures/files/board_empty.txt', 'text/plain').read } 
  let(:without_generation) { fixture_file_upload('spec/fixtures/files/board_without_gen.txt', 'text/plain').read }
  let(:without_dim) { fixture_file_upload('spec/fixtures/files/board_without_dim.txt', 'text/plain').read }
  let(:wrong_rows) { fixture_file_upload('spec/fixtures/files/board_invalid_rows.txt', 'text/plain').read }
  let(:corrupted_grid) { fixture_file_upload('spec/fixtures/files/board_corrupted_grid.txt', 'text/plain').read }

  describe '#call' do
    context 'when the file content is valid' do
      it 'parse the content and return the correct attributes' do
        service = described_class.new(valid_file)
        result = service.call

        expect(result[:generation]).to eq(1)
        expect(result[:rows]).to eq(8)
        expect(result[:cols]).to eq(16)
        expect(result[:current_state]).to eq([
          [".",".",".",".",".",".",".",".",".",".",".",".",".",".",".","."],
          [".",".",".","*",".",".",".",".",".",".",".",".",".",".",".","."],
          [".","*",".","*",".",".",".",".",".",".",".",".",".",".",".","."],
          [".",".","*","*",".",".",".",".",".",".",".",".",".",".",".","."],
          [".",".",".",".",".",".",".",".",".",".",".",".",".",".",".","."],
          [".",".",".",".",".",".",".",".",".",".",".",".",".",".",".","."],
          [".",".",".",".",".",".",".",".",".",".",".",".",".",".",".","."],
          [".",".",".",".",".",".",".",".",".",".",".",".",".",".",".","."],
        ])
      end
    end

    context 'when the file is empty' do
      it 'raises an error for empty file' do
        service = described_class.new(empty_file)
        expect { service.call }.to raise_error("File is empty or invalid")
      end
    end

    context 'when the generation line is missing' do
      it 'raises an error for missing generation' do
        service = described_class.new(without_generation)
        expect { service.call }.to raise_error('Missing or malformated generation line')
      end
    end

    context 'when the dimensions line is missing' do
      it 'raises an error for missing dimensions line' do
        service = described_class.new(without_dim)
        expect { service.call }.to raise_error('Missing or malformated dimensions line')
      end
    end

    context 'when the row size is incorrect' do
      it 'raises an error for wrong row size' do
        service = described_class.new(wrong_rows)
        expect { service.call }.to raise_error('Grid dimensions not match with the specified rows and columns')
      end
    end

    context 'when the grid not match with the dimensions' do
      it 'raises an error when the grid is inconsistent with the dimensions' do
        service = described_class.new(corrupted_grid)
        expect { service.call }.to raise_error('Grid dimensions not match with the specified rows and columns')
      end
    end
  end
end
