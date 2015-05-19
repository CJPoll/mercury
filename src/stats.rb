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
  def boost stat, by:, called:
    @boosts ||= {}
    @boosts[stat] ||= {percent: {}, points: {}}

    @boosts[stat][by.type][called] = by
  end

  def percentage_boost on:
    return 1 if @boosts.nil? || @boosts[on].nil? || @boosts[on][:percent].empty?
    return (boost_stat on: on, of_type: :percent) + 1
  end

  def point_boost on:
    return 0 if @boosts.nil? || @boosts[on].nil? || @boosts[on][:points].empty?
    return (boost_stat on: on, of_type: :points) + 0
  end

  def boost_stat on:, of_type:
    @boosts[on] ||= {percent: {}, points: {}}

    # Called buff here instead of boost because there's already a method named
    # boost
    buff = @boosts[on][of_type].inject(0) do |sum, (name, modifier)|
      sum += modifier.amount
    end

    return buff
  end

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
