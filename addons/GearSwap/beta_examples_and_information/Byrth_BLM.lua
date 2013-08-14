function get_sets()
	sets = {}
	sets.precast_Stun = {main="Apamajas II",sub="Arbuda Grip",ammo="Hasty Pinion",
		head="Zelus Tiara",neck="Aesir Torque",ear1="Belatz Pearl",ear2="Loquacious Earring",
		body="Hedera Cotehardie",hands="Repartie Gloves",lring="Balrahn's Ring",rring="Angha Ring",
		back="Swith Cape",waist="Goading Belt",legs="Rubeus Spats",feet="Rostrum Pumps"}
	
	sets.precast_Stun_MAcc = {main="Apamajas II",sub="Wizzan Grip",ranged="Aureole",
		head="Zelus Tiara",neck="Aesir Torque",ear1="Belatz Pearl",ear2="Loquacious Earring",
		body="Hedera Cotehardie",hands="Repartie Gloves",lring="Balrahn's Ring",rring="Angha Ring",
		back="Merciful Cape",waist="Goading Belt",legs="Auspex Slops",feet="Bokwus Boots"}
		
	sets.precast_FastCast_ElementalMagic = {head="Goetia Petasos +2",neck="Stoicheion Medal",ear2="Loquacious Earring",
		body="Anhur Robe",hands="Repartie Gloves",lring="Prolix Ring",back="Swith Cape",legs="Orvail Pants",feet="Rostrum Pumps"}
		
	sets.precast_FastCast_Other = {head="Nares Cap",neck="Orunmila's Torque",ear2="Loquacious Earring",
		body="Anhur Robe",hands="Repartie Gloves",lring="Prolix Ring",back="Swith Cape",waist="Siegel Sash",legs="Orvail Pants",feet="Rostrum Pumps"}
		
		
	
	sets.aftercast_Idle = {main="Terra's Staff",sub="Arbuda Grip",ammo="Mana ampulla",
		head="Nares Cap",neck="Twilight Torque",ear1="Gifted earring",ear2="Loquacious Earring",
		body="Goetia Coat +2",hands="Serpentes Cuffs",ring1="Dark Ring",ring2="Dark Ring",
		back="Umbra Cape",waist="Hierarch Belt",legs="Nares Trews",feet="Herald's Gaiters"}
				
	sets.Resting = {main="Numen Staff",sub="Ariesian Grip",ammo="Mana ampulla",
		head="Hydra Beret",neck="Eidolon Pendant",ear1="Relaxing Earring",ear2="Antivenom Earring",
		body="Heka's Kalasiris",hands="Nares Cuffs",ring1="Star Ring",ring2="Angha Ring",
		back="Vita Cape",waist="Austerity Belt",legs="Nares Trews",feet="Serpentes Sabots"}
	
	sets.midcast_ElementalMagic = {main="Chatoyant Staff",sub="Wizzan Grip",ammo="Snow Sachet",
		head="Nares Cap",neck="Eddy Necklace",ear1="Hecate's Earring",ear2="Novio Earring",
		body="Nares Saio",hands="Yaoyotl Gloves",ring1="Icesoul Ring",ring2="Icesoul Ring",
		back="Refraction Cape",waist="Wanion Belt",legs="Akasha Chaps",feet="Goetia Sabots +2"}
	
	sets.midcast_DarkMagic = {main="Chatoyant Staff",sub="Arbuda Grip",ammo="Hasty Pinion",
		head="Appetence Crown",neck="Aesir Torque",ear1="Hirudinea Earring",ear2="Loquacious Earring",
		body="Hedera Cotehardie",hands="Sorcerer's Gloves +2",ring1="Balrahn's Ring",ring2="Excelsis Ring",
		back="Merciful Cape",waist="Goading Belt",legs="Wizard's Tonban +1",feet="Goetia Sabots +2"}
	
	sets.midcast_EnfeeblingMagic = {main="Chatoyant Staff",sub="Arbuda Grip",ammo="Savant's Treatise",
		head="Nares Cap",neck="Enfeebling Torque",ear1="Psystorm Earring",ear2="Lifestorm Earring",
		body="Nares Saio",hands="Yaoyotl Gloves",ring1="Balrahn's Ring",ring2="Angha Ring",
		back="Goetia Mantle",waist="Wanion Belt",legs="Rubeus Spats",feet="Bokwus Boots"}
	
	sets.midcast_HealingMagic = {}
	
	sets.midcast_DivineMagic = {}
	
	sets.midcast_EnhancingMagic = {}
	
	sets.midcast_Cure = {main="Arka IV",body="Heka's Kalasiris",hands="Augur's Gloves",legs="Nares Trews"}
	
	sets.midcast_Stoneskin = {main="Kirin's Pole",neck="Stone Gorget",waist="Siegel Sash",legs="Shedir Seraweels"}
	
	sets.Obi_Fire = {back='Twilight Cape',lring='Zodiac Ring'}
	sets.Obi_Earth = {back='Twilight Cape',lring='Zodiac Ring'}
	sets.Obi_Water = {back='Twilight Cape',lring='Zodiac Ring'}
	sets.Obi_Wind = {waist='Furin Obi',back='Twilight Cape',lring='Zodiac Ring'}
	sets.Obi_Ice = {waist='Hyorin Obi',back='Twilight Cape',lring='Zodiac Ring'}
	sets.Obi_Thunder = {waist='Rairin Obi',back='Twilight Cape',lring='Zodiac Ring'}
	sets.Obi_Light = {waist='Korin Obi',back='Twilight Cape',lring='Zodiac Ring'}
	sets.Obi_Dark = {waist='Anrin Obi',back='Twilight Cape',lring='Zodiac Ring'}
	
	stuntarg = 'Shantotto'
end

function precast(spell,action)
	if spell.english == 'Impact' then
		cast_delay(1.5)
		equip(sets['precast_FastCast'],{body="Twilight Cloak"})
		if not buffactive.elementalseal then
			add_to_chat(8,'--------- Elemental Seal is down ---------')
		end
	elseif spell.english == 'Stun' then
		if spell.target.name == 'Paramount Mantis' or spell.target.name == 'Tojil' then
			equip(sets['precast_Stun_MAcc'])
		else
			equip(sets['precast_Stun'])
		end
		if stuntarg ~= 'Shantotto' then
			send_command('@input /t '..stuntarg..' ---- Byrth Stunned!!! ---- ')
		end
		--force_send()
	elseif action.type == 'Magic' then
		if spell.skill == 'ElementalMagic' then
			equip(sets['precast_FastCast_ElementalMagic'])
		else
			equip(sets['precast_FastCast_Other'])
		end
	end
end

function midcast(spell,action)
	if string.find(spell.english,'Cur') then 
		weathercheck(spell.element,sets['midcast_Cure'])
	elseif spell.english == 'Impact' then
		local tempset = sets['midcast_'..spell.type]
		tempset['body'] = 'Twilight Cloak'
		tempset['head'] = 'empty'
		weathercheck(spell.element,tempset)
	elseif spell.english == 'Stoneskin' then
		equip(sets['midcast_Stoneskin'])
	elseif spell.skill then
		weathercheck(spell.element,sets['midcast_'..spell.skill])
	end
	
	if spell.english == 'Sneak' then
		send_command('@wait 1.8;cancel 71;')
	end
end

function aftercast(spell,action)
	equip(sets['aftercast_Idle'])
	if spell.english == 'Sleep' or spell.english == 'Sleepga' then
		send_command('@wait 55;input /echo ------- '..spell.english..' is wearing off in 5 seconds -------')
	elseif spell.english == 'Sleep II' or spell.english == 'Sleepga II' then
		send_command('@wait 85;input /echo ------- '..spell.english..' is wearing off in 5 seconds -------')
	elseif spell.english == 'Break' or spell.english == 'Breakga' then
		send_command('@wait 25;input /echo ------- '..spell.english..' is wearing off in 5 seconds -------')
	end
end

function status_change(old,new)
	if new == 'Resting' then
		equip(sets['Resting'])
	else
		equip(sets['aftercast_Idle'])
	end
end

function buff_change(status,gain_or_loss)
end

function pet_midcast(spell,action)
end

function pet_aftercast(spell,action)
end

function self_command(command)
	if command == 'stuntarg' then
		stuntarg = target.name
	end
end

-- This function is user defined, but never called by GearSwap itself. It's just a user function that's only called from user functions. I wanted to check the weather and equip a weather-based set for some spells, so it made sense to make a function for it instead of replicating the conditional in multiple places.

function weathercheck(spell_element,set)
	if spell_element == world.weather_element or spell_element == world.day_element then
		equip(set,sets['Obi_'..spell_element])
	else
		equip(set)
	end
end