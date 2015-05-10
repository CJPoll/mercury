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
			return self.member.agility <=> other.member.agility
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
		@queue.pop.member
	end
end
