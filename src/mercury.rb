class Hash
	def required *options
		options.each do |option|
			raise "Missing required option: #{option}" unless self.include? option
		end
	end

	def internalize obj, *options
		options.each do |option|
			obj.send "#{option.to_s}=", options[option]
		end
	end
end

module Mercury
end
