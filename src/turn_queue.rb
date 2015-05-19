require './src/mercury'
require 'pqueue'

class Mercury::TurnQueue
	class TurnQueueMember
		include Comparable

		attr_accessor :member, :round_number

		def initialize options = {}
			required_options = [:member, :round_number]

			options.required *required_options
			options.internalize self, *required_options
		end

		def <=> other
			unless self.round_number == other.round_number
				return -1 if self.round_number > other.round_number
				return 1
			end

			unless self.member.agility == other.member.agility
				return self.member.agility <=> other.member.agility
			end

			return self.member.stat_total <=> other.member.stat_total
		end
	end

	def initialize
		@queue = PQueue.new
	end

	def add options = {}
		options.required(:member, :round_number)

		new_member = TurnQueueMember.new options

		@queue.push new_member
	end

	def pop
		queue_member = @queue.pop
		queue_member = queue_member.member unless queue_member.nil?
		queue_member
	end
end
