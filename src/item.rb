# This module is for methods that items are expected to implement. It mostly
# includes inventory management, but also allows for callbacks on certain
# events (on entering inventory, on leaving inventory, on moving to different
# character, etc.)
module Collectible
end


# This module defines methods that equipable items are expected to implement.
# This includes callbacks like on_equip, on_unequip, etc.
module Mercury::Items::Equippable
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def on event, &block
			define_method event, block
		end
	end
end

# This module is for items which are stackable in the inventory. It implements
# methods which define maximum stack size, along with others. This module is
# mutually exclusive to Equipable. That is, Equipable items should not also be
# stackable.
module Stackable
end
