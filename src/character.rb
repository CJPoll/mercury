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
end

class Character
	include Mercury::Stats::BaseStatMethods
	include Mercury::Stats::StatBoostRegistration
end
