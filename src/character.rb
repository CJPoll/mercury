class Integer
  class Modifier
    attr_reader :amount, :type

    def initialize amount:, type:
      @amount = amount
      @type = type
    end
  end

  def points
    return Modifier.new(amount: self, type: :points)
  end

  def percent
    return Modifier.new(amount: self * 0.01, type: :percent)
  end
end

module Mercury::Actor::Equips
	def equip item
		item.equip self
	end

	def unequip item
		item.unequip self
	end
end

class Mercury::Actor::Character
	include Mercury::Stats::BaseStatMethods
	include Mercury::Stats::StatBoostRegistration
	include Mercury::Actor::Equips
end
