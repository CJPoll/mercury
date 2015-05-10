require 'spec_helper'

describe Mercury::TurnQueue do
	class FakeMember
	end

	context 'tie' do
		before :each do
			@queue = Mercury::TurnQueue.new
		end

		it 'orders by round number' do
			@member1 = FakeMember.new
			@member2 = FakeMember.new

			@queue.add member: @member1, round_number: 1
			@queue.add member: @member2, round_number: 2

			expect(@queue.pop).to be @member2
			expect(@queue.pop).to be @member1
		end

		it 'breaks a tie by checking agility'
		it 'breaks an agility tie by checking total stats'
		it 'breaks a total stat tie by picking one at random (uniformly)'
	end

	context 'single insertions' do
		it 'sorts two elements with different priorities correctly'
	end

	context 'multiple insertions' do
		it 'allows an element to be inserted multiple times with different priorities'
		it 'allows an element to be inserted multiple times with the same priority'
	end
end
