describe Mercury::Weapons::MightyAxe do
	subject { Mercury::Weapons::MightyAxe.new }
	before :each do
		@character = Mercury::Actor::Character.new power: 10, fortitude: 10
	end

	it 'boosts power by 20 points' do
		@character.equip( subject )
		expect( @character.power ).to eq( 30 )
	end

	it 'boosts fortitude by 20 percent' do
		@character.equip( subject )
		expect( @character.fortitude ).to eq( 12 )
	end

	it 'removes the power boost when unequipped' do
		@character.equip( subject )
		@character.unequip( subject )

		expect( @character.power ).to eq( 10 )
	end

	it 'removes the fortitude boost when unequipped' do
		@character.equip( subject )
		@character.unequip( subject )

		expect( @character.fortitude ).to eq( 10 )
	end
end
