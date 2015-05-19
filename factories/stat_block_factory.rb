require 'factory_girl'
FactoryGirl.define do
	factory :core_stat_block, class: Mercury::Stats::CoreStatBlock do
		base_strength 		10
		base_fortitude 		11
		base_agility 		12
		base_intelligence 	13
		base_soul 			14
	end
end
