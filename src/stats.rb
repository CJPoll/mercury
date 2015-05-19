require './src/mercury_module.rb'

module Mercury::Stats
	STATS = [:power, :fortitude, :agility, :intelligence, :soul]
end

module Mercury::Stats::BaseStatMethods
	base_stats = Mercury::Stats::STATS.map {|stat| "base_#{stat.to_s}".to_sym}
	attr_reader *base_stats

	# Creates a method for each given stat which returns the base stat's value
	def self.stats *stats
		stats.each do |stat|
			method_name = stat
			define_method method_name do 
				self.send "base_#{stat}"
			end
		end
	end

	stats *Mercury::Stats::STATS
end

class Mercury::Stats::CoreStatBlock
	include Mercury::Stats::BaseStatMethods

	def initialize power: 0, fortitude: 0, agility: 0, intelligence: 0, soul: 0
		@base_power = power
		@base_fortitude = fortitude
		@base_agility = agility
		@base_intelligence = intelligence
		@base_soul = soul
	end
end
