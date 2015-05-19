require 'spec_helper'

describe Mercury::TurnQueue do
	class FakeMember
		attr_accessor :agility, :stat_total

		def initialize agility: , stat_total:
      @agility = agility
      @stat_total = stat_total
		end
	end

	context 'tie' do
		before :each do
			@queue = Mercury::TurnQueue.new
		end

		it 'orders by round number' do
			@member1 = FakeMember.new agility: 1, stat_total: 1
			@member2 = FakeMember.new agility: 1, stat_total: 1
			@member3 = FakeMember.new agility: 1, stat_total: 1
			@member4 = FakeMember.new agility: 1, stat_total: 1

			@queue.add member: @member1, round_number: 1
			@queue.add member: @member3, round_number: 3
			@queue.add member: @member2, round_number: 2
			@queue.add member: @member4, round_number: 4

			expect(@queue.pop).to be @member1
			expect(@queue.pop).to be @member2
			expect(@queue.pop).to be @member3
			expect(@queue.pop).to be @member4
		end

		it 'breaks a tie by checking agility' do
			@member1 = FakeMember.new agility: 5, stat_total: 1
			@member2 = FakeMember.new agility: 8, stat_total: 1

			@queue.add member: @member1, round_number: 1
			@queue.add member: @member2, round_number: 1

			expect(@queue.pop).to be @member2
			expect(@queue.pop).to be @member1
		end

		it 'breaks an agility tie by checking total stats' do
			@member1 = FakeMember.new agility: 5, stat_total: 10
			@member2 = FakeMember.new agility: 5, stat_total: 13

			@queue.add member: @member1, round_number: 1
			@queue.add member: @member2, round_number: 1

			expect(@queue.pop).to be @member2
			expect(@queue.pop).to be @member1
		end
	end

	context 'multiple insertions' do
		before :each do
			@queue = Mercury::TurnQueue.new
		end

		it 'allows an element to be inserted multiple times with different priorities' do
			@member1 = FakeMember.new agility: 5, stat_total: 1
			@member2 = FakeMember.new agility: 8, stat_total: 1

			@queue.add member: @member1, round_number: 1
			@queue.add member: @member2, round_number: 1
			@queue.add member: @member1, round_number: 2

			expect(@queue.pop).to be @member2 # higher agility
			expect(@queue.pop).to be @member1
			expect(@queue.pop).to be @member1
		end
	end

	context 'empty' do
		before :each do
			@queue = Mercury::TurnQueue.new
		end

		it 'pops nil if empty' do
			expect(@queue.pop).to be_nil
		end
	end
end
