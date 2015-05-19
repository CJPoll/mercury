require './spec/spec_helper'

describe Character do
  TEST_CLASS = Character
  before :each do
    @character = TEST_CLASS.new power: 10
  end

  it 'allows a point boost to a stat' do
    expect(@character.base_power).to eq 10
    expect(@character.power).to eq 10

    @character.boost :power, by: 10.points, called: :test_boost

    expect(@character.base_power).to eq 10
    expect(@character.power).to eq 20
  end

  it 'can remove a point-type boost to a stat' do
    @character.boost :power, by: 10.points, called: :test_boost

    expect(@character.base_power).to eq 10
    expect(@character.power).to eq 20

    @character.remove_boost from: :power, called: :test_boost

    expect(@character.base_power).to eq 10
    expect(@character.power).to eq 10
  end


  it 'allows a boost to a stat as a percentage of the base' do
    expect(@character.base_power).to eq 10
    expect(@character.power).to eq 10

    @character.boost :power, by: 30.percent, called: :test_boost

    expect(@character.base_power).to eq 10
    expect(@character.power).to eq 13
  end

  it 'can remove a percent-type boost to a stat'
end
