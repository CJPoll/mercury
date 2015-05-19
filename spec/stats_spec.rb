require 'spec_helper'

TEST_CLASS = Mercury::Stats::CoreStatBlock
STATS = Mercury::Stats::STATS

describe Mercury::Stats::CoreStatBlock do
  context '::new' do
    it 'defaults all stats to 0' do
      stat_block = TEST_CLASS.new

      STATS.each do |stat|
        stat_name = "base_#{stat}"
        base_stat = stat_block.send stat_name
        expect(base_stat).to eq(0), "expected #{stat_name} to be 0; was #{base_stat}"
      end
    end
  end

  context 'effective stats' do
    before :each do
      @statblock = TEST_CLASS.new(
        power: 10,
        fortitude: 11,
        agility: 12,
        intelligence: 13,
        soul: 14
      )
    end

    it 'can retrieve the current effective power' do
      expect(@statblock.power).to eq 10
    end

    it 'can retrieve the current effective fortitude' do
      expect(@statblock.fortitude).to eq 11
    end

    it 'can retrieve the current effective agility' do
      expect(@statblock.agility).to eq 12
    end

    it 'can retrieve the current effective intelligence' do
      expect(@statblock.intelligence).to eq 13
    end

    it 'can retrieve the current effective soul' do
      expect(@statblock.soul).to eq 14
    end
  end
end
