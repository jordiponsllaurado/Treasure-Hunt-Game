require 'spec_helper'

describe Board do
  describe 'boundaries' do
    it 'returns true when the boundaries are correct' do
      expect(Board.check_boundaries(0, 10)).to be true
    end

    it 'returns false when the x coord is out of the board' do
      expect(Board.check_boundaries(11, 1)).to be false
    end

    it 'returns false when the y coord is out of the board' do
      expect(Board.check_boundaries(1, -1)).to be false
    end

    it 'returns false when both coords are out of the board' do
      expect(Board.check_boundaries(11, 11)).to be false
    end
  end
end