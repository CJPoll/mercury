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
        base = self.send "base_#{stat}"
        percent_buff = percentage_boost on: stat
        point_buff = point_boost on: stat

        base * percent_buff + point_buff
      end
    end
  end

  def initialize stats = {}
    Mercury::Stats::STATS.each do |stat|
      instance_variable_set("@base_#{stat.to_s}", stats[stat] || 0)
    end
  end

  stats *Mercury::Stats::STATS
end

module Mercury::Stats::StatBoostRegistration
  # Registers a boost (a.k.a. buff) on a single stat.
  #
  # It can be a point boost (+10 agility) or it can be a percent boost.
  #
  # Percent boosts are based on the stat's base. An example of this is shown
  # below.
  #
  # @parameters:
  #   stat: A symbol naming the stat to be boosted (example: :intelligence)
  #
  # Examples:
  #   `character.boost :agility, by: 10.percent, called: :test_boost`
  #     Assuming base agility of 100 and no other buffs, the character's
  #     effective agility is now 110.
  #
  #   `character.boost :soul, by: 20.points, called: :test_boost`
  #     Assuming base soul of 100 and no other buffs, the character's
  #     effective soul is now 120.
  #
  #   `character.boost :intelligence by 20.percent, called: :some_buff`
  #   `character.boost :intelligence by 10.percent, called: :another_buff`
  #     Assuming a base intelligence of 100 and only these two buffs, the
  #     character's effective intelligence is now 130.
  #
  #     This is calculated by combining the percent boosts (20 + 10 = 30 percent)
  #     and multiplying the result by the base (100 * 30% = 30) and adding it to
  #     the base (100 + 30 = 130)
  def boost stat, by:, called:
    @boosts |||= {}
    @boosts[stat] ||= {percent: {}, points: {}}

    @boosts[stat][by.type][called] = by
  end

  # Calculates how much of a percentage boost a given stat has. Really just a 
  # wrapper around boost_stat with a default value for certain situations
  def percentage_boost on:
    return 1 if @boosts.nil? || @boosts[on].nil? || @boosts[on][:percent].empty?
    return (boost_stat on: on, of_type: :percent) + 1
  end

  # Calculates the point bonus to a given stat. Really just a wrapper around
  # boost_stat with a default value for certain situations
  def point_boost on:
    return 0 if @boosts.nil? || @boosts[on].nil? || @boosts[on][:points].empty?
    return (boost_stat on: on, of_type: :points) + 0
  end

  # Implements calculating the percent or point boost of any given stat.
  def boost_stat on:, of_type:
    @boosts[on] ||= {percent: {}, points: {}}

    # Called buff here instead of boost because there's already a method named
    # boost
    buff = @boosts[on][of_type].inject(0) do |sum, (name, modifier)|
      sum += modifier.amount
    end

    return buff
  end

  # Removes boosts from a given stat which have a given ID/name
  def remove_boost from:, called:
    named_percent_hash = @boosts[from][:percent]
    named_points_hash = @boosts[from][:points]

    named_percent_hash.each do |name, modifier|
      if name == called
        named_percent_hash.delete name
      end
    end

    named_points_hash.each do |name, modifier|
      if name == called
        named_points_hash.delete name
      end
    end
  end
end

class Mercury::Stats::CoreStatBlock
  include Mercury::Stats::BaseStatMethods
  include Mercury::Stats::StatBoostRegistration
end
