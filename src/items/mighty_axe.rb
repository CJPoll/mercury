require './src/item'

class Mercury::Weapons::MightyAxe
	include Mercury::Items::Equippable

	on :equip do |character|
		character.boost :power, by: 20.points, set_by: self
		character.boost :fortitude, by: 20.percent, set_by: self
	end

	on :unequip do |character|
		character.remove_boost from: :power, set_by: self
		character.remove_boost from: :fortitude, set_by: self
	end
end
