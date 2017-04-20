require 'spec_helper'

describe Game do
  describe '#Game' do
    before do
      Game.create_game
      DBHelper.update_treasure(1, 5, 5)
      DBHelper.update_treasure(2, 0, 0)
    end

    describe 'boundaries' do
      it 'returns true when the boundaries are correct' do
        expect(Game.check_boundaries(0, 10)).to be true
      end

      it 'returns false when the x coord is out of the board' do
        expect(Game.check_boundaries(11, 1)).to be false
      end

      it 'returns false when the y coord is out of the board' do
        expect(Game.check_boundaries(1, -1)).to be false
      end

      it 'returns false when both coords are out of the board' do
        expect(Game.check_boundaries(11, 11)).to be false
      end
    end

    describe 'send coords' do
      it 'returns success when the user finds all the treasures' do
        allow(STDIN).to receive(:gets) { 'Y' }
        Game.send_coord(0, 0)
        expect(Game.send_coord(5, 5)).to eql(Game::GAME_FINISHED)
      end

      it 'returns finished but not completed when the user only finds one treasure' do
        allow(STDIN).to receive(:gets) { 'N' }
        expect(Game.send_coord(5, 5)).to eql(Game::SUCCESS_AND_FINISH)
      end

      it 'returns finished and continue when the user only finds one treasure and wants to continue' do
        allow(STDIN).to receive(:gets) { 'Y' }
        expect(Game.send_coord(5, 5)).to eql(Game::SUCCESS_AND_CONTINUE)
      end


      it 'returns hot when the coords are 1 position far of the treasure' do
        expect(Game.send_coord(4, 4)).to eql(Game::HOT)
      end

      it 'returns warm when the coords are 2 positions far of the treasure' do
        expect(Game.send_coord(3, 3)).to eql(Game::WARM)
      end

      it 'returns warm when the coords are 2 positions far of the treasure' do
        expect(Game.send_coord(9, 9)).to eql(Game::COLD)
      end
    end

    describe 'solution' do
      it 'gets the correct solution' do
        expected = {x: 5, y: 5}
        expect(Game.get_treasure(1)).to eql(expected)
      end
    end

    describe 'attempts' do
      it 'returns 0' do
        Game.create_game
        expect(DBHelper.get_attempts).to eql(0)
      end

      it 'returns 1 if the player picked one position' do
        Game.create_game
        allow(STDIN).to receive(:gets) { 'Y' }
        Game.send_coord(2, 2)
        expect(DBHelper.get_attempts).to eql(1)
      end

      it 'returns game over when the player used more than 5 attempnts' do
        Game.create_game
        Game.send_coord(2, 2)
        Game.send_coord(1, 2)
        Game.send_coord(2, 3)
        Game.send_coord(2, 9)
        expect(Game.send_coord(1, 2)).to eql(Game::GAME_OVER)
      end
    end
  end

  #TODO test delete treasure
end