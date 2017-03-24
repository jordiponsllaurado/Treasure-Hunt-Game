require 'spec_helper'

describe Game do
  describe '#Game' do
    before do
      DBHelper.create_db_table
      DBHelper.update_treasure(5, 5)
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
      it 'returns success when the coords are the treasure' do
        expect(Game.send_coord(5, 5)).to eql('SUCESS!!!!!!!!!!!!!!')
      end

      it 'returns hot when the coords are 1 position far of the treasure' do
        expect(Game.send_coord(4, 4)).to eql('HOT HOT HOT!!!')
      end

      it 'returns warm when the coords are 2 positions far of the treasure' do
        expect(Game.send_coord(3, 3)).to eql('WARM!')
      end

      it 'returns warm when the coords are 2 positions far of the treasure' do
        expect(Game.send_coord(2, 2)).to eql('COLD!!!')
      end
    end

    describe 'solution' do
      it 'gets the correct solution' do
        expected = {x: 5, y: 5}
        expect(Game.get_treasure).to eql(expected)
      end
    end
  end

end