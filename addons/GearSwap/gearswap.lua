--Copyright (c) 2013, Byrthnoth
--All rights reserved.

--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:

--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of <addon name> nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.

--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


language = 'english'
file = require 'filehelper'
require 'sets'
require 'stringhelper'
require 'helper_functions'

require 'resources'
require 'equip_processing'
require 'targets'
require 'refresh'
require 'user_functions'

_addon = {}
_addon.name = 'GearSwap'
_addon.version = '0.604'
_addon.commands = {'gs','gearswap'}

function event_load()
	debugging = 1
	
	
	if dir_exists('../addons/GearSwap/data/logs') then
		logging = true
		logfile = io.open('../addons/GearSwap/data/logs/NormalLog'..tostring(os.clock())..'.log','w+')
		logit(logfile,'GearSwap LOGGER HEADER\n')
	end
	
	send_command('@alias gs lua c gearswap')
	refresh_globals()
	_global.force_send = false
	
	if world.logged_in then
		refresh_user_env()
		if debugging >= 1 then send_command('@unload spellcast;') end
	end
end

function event_unload()
	if logging then	logfile:close() end
	send_command('@unalias gs')
end

function event_addon_command(...)
	local command = table.concat({...},' ')
	if logging then	logit(logfile,'\n\n'..tostring(os.clock)..command) end
	local splitup = split(command,' ')
	if splitup[1]:lower() == 'c' then
		if gearswap_disabled then return end
		if splitup[2] then equip_sets('self_command',_raw.table.concat(splitup,' ',2,#splitup))
		else
			add_to_chat(123,'GearSwap: No self command passed.')
		end
	elseif splitup[1]:lower() == 'equip' and not midaction then
		if gearswap_disabled then return end
		local set_split = split(_raw.table.concat(splitup,' ',2,#splitup):gsub('[%[%]\']',''),'%.')
		local n = 1
		local tempset = user_env.sets
		while n <= #set_split do
			if tempset[set_split[n]] then
				tempset = tempset[set_split[n]]
				if n == #set_split then
					equip_sets('equip_command',tempset)
					break
				else
					n = n+1
				end
			else
				add_to_chat(123,'GearSwap: Equip command cannot be completed. That set does not exist.')
				break
			end
		end
	elseif splitup[1]:lower() == 'disable' then
		gearswap_disabled = not gearswap_disabled
		if gearswap_disabled then
			write('GearSwap Disabled')
		else
			write('GearSwap Enabled')
		end
	elseif splitup[1]:lower() == 'reload' then
		refresh_user_env()
	elseif strip(splitup[1]) == 'debugmode' then
		_global.debug_mode = not _global.debug_mode
		write('Debug Mode set to '..tostring(_global.debug_mode)..'.')
	elseif strip(splitup[1]) == 'showswaps' then
		_global.show_swaps = not _global.show_swaps
		write('Show Swaps set to '..tostring(_global.show_swaps)..'.')
	else
		write('command not found')
	end
end

function midact()
	if not action_sent then
		if debugging >= 1 then add_to_chat(123,'GearSwap: Had to force the command to send.') end
		send_check(true)
	end
	action_sent = false
end

function event_outgoing_text(original,modified)
	if gearswap_disabled then return modified end
	
	local temp_mod = convert_auto_trans(modified)
	local splitline = split(temp_mod,' ')
	local command = splitline[1]

	local a,b,abil = string.find(temp_mod,'"(.-)"')
	if abil then
		abil = abil:lower()
	elseif #splitline == 3 then
		abil = splitline[2]:lower()
	end
	
	local temptarg = valid_target(splitline[#splitline])
	
	if command == '/raw' then
		return _raw.table.concat(splitline,' ',2,#splitline)
	elseif command_list[command] and temptarg and validabils[language][abil] and not midaction then
		if logging then	logit(logfile,'\n\n'..tostring(os.clock)..'(93) temp_mod: '..temp_mod) end
			
		send_command('@wait 1;lua invoke gearswap midact')
		
		local r_line, s_type
			
		if command_list[command] == 'Magic' then
			r_line = r_spells[validabils[language][abil:lower()]['Magic']]
			r_line.name = r_line[language]
			s_type = 'Magic' -- command_list[r_spells[validabils[language][abil:lower()]['Magic']]['prefix']]
		elseif command_list[command] == 'Ability' then
			r_line = r_abilities[validabils[language][abil:lower()]['Ability']]
			r_line.name = r_line[language]
			s_type = 'Ability' -- command_list[r_abilities[validabils[language][abil:lower()]['Ability']]['prefix']]
		elseif command_list[command] == 'Item' then
			r_line = r_items[validabils[language][abil:lower()]['Item']]
			r_line.name = r_line[language]
			r_line.prefix = '/item'
			r_line.type = 'Item'
			s_type = 'Item'
		elseif debugging then
			write('this case should never be hit '..command)
		end
		
		_global.storedtarget = temptarg
		
		r_line = aftercast_cost(r_line)
		
		storedcommand = r_line['prefix']..' "'..r_line[language]..'" '

		equip_sets('precast',r_line,{type=s_type})

		return ''
	elseif command_list[command] == 'Ranged Attack' and temptarg and not midaction then
		if logging then	logit(logfile,'\n\n'..tostring(os.clock)..'(93) temp_mod: '..temp_mod) end

		rline = ranged_line
		send_command('@wait 1;lua invoke gearswap midact')
		
		_global.storedtarget = temptarg
		
		r_line = aftercast_cost(rline)
			
		storedcommand = r_line['prefix']..' '
		equip_sets('precast',r_line,{type="Ranged Attack"})

		return ''
	elseif midaction and validabils[language][tostring(abil):lower()] then
		if logging then	logit(logfile,'\n\n'..tostring(os.clock)..'(122) Canceled: '..temp_mod) end
		return ''
	end
	return modified
end

function event_incoming_text(original,modified,mode)
	if gearswap_disabled then return modified, color end
	if original == '...A command error occurred.' or original == 'You can only use that command during battle.' or original == 'You cannot use that command here.' then
		if logging then	logit(logfile,'\n\n'..tostring(os.clock)..'(130) Client canceled command detected: '..mode..' '..original) end
		equip_sets('aftercast',{name='Invalid Spell'},{type='Recast'})
	end
	return modified,color
end

function event_incoming_chunk(id,data)
	if gearswap_disabled then return end
	cur_ID = data:byte(3,4)
	if prev_ID == nil then
		prev_ID = cur_ID
	end
	persistant_sequence[data:byte(3,4)] = true  ---------------------- TEMPORARY TO INVESTIGATE LAG ISSUES IN DELVE
	if data:byte(3,4) ~= 0x00 then
		if not persistant_sequence[data:byte(3,4)-1] then
			if logging then	logit(logfile,'\n\n'..tostring(os.clock)..'(140) Packet dropped or out of order: '..cur_ID..' '..prev_ID) end
		end
	end
	prev_ID = cur_ID
	if prev_ID == 0xFF then
		table.reassign(persistant_sequence,{})
	end

	if id == 0x050 then
		if sent_out_equip[data:byte(6)] == data:byte(5) then
			sent_out_equip[data:byte(6)] = nil
			send_check()
		end
	end
end

function event_zone_change(from_id, from, to_id, to)
	prev_ID = 0
end

function event_outgoing_chunk(id,data)
	if id == 0x015 then
		lastbyte = data:byte(7,8)
	end
	if id == 0x01A then -- Action packet
		local abil_name
		actor_id = data:byte(8,8)*256^3+data:byte(7,7)*256^2+data:byte(6,6)*256+data:byte(5,5)
		index = data:byte(10,10)*256+data:byte(9,9)
		category = data:byte(12,12)*256+data:byte(11,11)
		param = data:byte(14,14)*256+data:byte(13,13)
		_unknown1 = data:byte(16,16)*256+data:byte(15,15)
		local actor_name = get_mob_by_id(actor_id)['name']
		local target_name = get_mob_by_index(index)['name']
		if category == 3 then
			abil_name = r_spells[param][language]
		elseif category == 7 then
			abil_name = r_abilities[param+768][language]
		elseif category == 9 then
			abil_name = r_abilities[param][language]
		elseif category == 16 then
			abil_name = 'Ranged Attack'
		end
		if logging then logit(logfile,'\n\nActor: '..tostring(actor_name)..'  Target: '..tostring(target_name)..'  Category: '..tostring(category)..'  param: '..tostring(abil_name or param)) end
		if abil_name then
			midaction = true
		end
	end
end

function event_action(act)
	if gearswap_disabled or act.category == 1 then return end
	
	local temp_player = get_player()
	local player_id = temp_player['id']
	-- Update player info for aftercast costs.
	player.tp = temp_player.vitals.tp
	player.mp = temp_player.vitals.mp
	player.mpp = temp_player.vitals.mpp
	
	local temp_pet,pet_id
	if temp_player.pet_index then
		temp_pet = get_mob_by_index(temp_player['pet_index'])
		pet_id = temp_pet.id
	end
	
	if player_id ~= act['actor_id'] and act['actor_id']~=pet_id then
		return -- If the action is not being used by the player, the pet, or is a melee attack then abort processing.
	end
	
	local prefix = ''
	
	if act['actor_id'] == pet_id then 
		prefix = 'pet_'
	end
	
	local spell = get_spell(act)
	local category = act.category
	
	if logging then	
		if spell then logit(logfile,'\n\n'..tostring(os.clock)..'(178) Event Action: '..tostring(spell.english)..' '..tostring(act['category']))
		else logit(logfile,'\n\nNil spell detected') end
	end
	
	if jas[category] or uses[category] or (readies[category] and act.param == 28787 and not category == 9) then
		local action_type = get_action_type(category)
		if readies[category] and act.param == 28787 and not category == 9 then
			action_type = 'Failure'
		end
		if type(user_env[prefix..'aftercast']) == 'function' then
			equip_sets(prefix..'aftercast',spell,{type=action_type})
		elseif user_env[prefix..'aftercast'] then
			midaction = false
			spelltarget = nil
			add_to_chat(123,'GearSwap: '..prefix..'aftercast() exists but is not a function')
		else
			midaction = false
			spelltarget = nil
		end
	elseif readies[category] and act.param ~= 28787 then
		if type(user_env[prefix..'midcast']) == 'function' then
			equip_sets(prefix..'midcast',spell,{type=get_action_type(category)})
		elseif user_env[prefix..'midcast'] then
			add_to_chat(123,'GearSwap: '..prefix..'midcast() exists but is not a function')
		end
	end
end

function event_action_message(actor_id,target_id,actor_index,target_index,message_id,param_1,param_2,param_3)
	if gearswap_disabled then return end
	if message_id == 62 then
		if type(user_env.aftercast) == 'function' then
			equip_sets('aftercast',r_items[param_1],{type='Failure'})
		elseif user_env.aftercast then
			midaction = false
			spelltarget = nil
			add_to_chat(123,'GearSwap: aftercast() exists but is not a function')
		else
			midaction = false
			spelltarget = nil
		end
	elseif unable_to_use:contains(message_id) then
		if logging then	logit(logfile,'\n\n'..tostring(os.clock)..'(195) Event Action Message: '..tostring(message_id)..' Interrupt') end
		if type(user_env.aftercast) == 'function' then
			equip_sets('aftercast',{name='Interrupt',type='Interrupt'},{type='Recast'})
		elseif user_env.aftercast then
			midaction = false
			spelltarget = nil
			add_to_chat(123,'GearSwap: aftercast() exists but is not a function')
		else
			midaction = false
			spelltarget = nil
		end
	end
end

function event_status_change(old,new)
	if gearswap_disabled or T{'Event','Other','Zoning','Dead'}:contains(old) or T{'Event','Other','Zoning','Dead'}:contains(new) then return end
	-- Event may not be a real status yet. This is a blacklist to prevent people from swapping out of crafting gear or when disengaging from NPCs.
	if old == '' then old = 'Idle' end
	equip_sets('status_change',new,old)
end

function event_gain_status(id,name)
	if gearswap_disabled then return end
	equip_sets('buff_change',name,'gain')
end

function event_lose_status(id,name)
	if gearswap_disabled then return end
	equip_sets('buff_change',name,'loss')
end

function event_job_change(mjob_id, mjob, mjob_lvl, sjob_id, sjob, sjob_lvl)
	if mjob ~= current_job_file then
		refresh_user_env()
	end
end

function event_login(name)
	send_command('@wait 2;lua i gearswap refresh_user_env;')
end

function event_day_change(day)
	send_command('@wait 0.5;lua invoke gearswap refresh_ffxi_info')
end

function event_weather_change(weather)
	refresh_ffxi_info()
end



function get_spell(act)
	local spell, abil_ID, effect_val = {}
	local msg_ID = act['targets'][1]['actions'][1]['message']
	
	if T{7,8,9}:contains(act['category']) then
		abil_ID = act['targets'][1]['actions'][1]['param']
	elseif T{3,4,5,6,11,13,14,15}:contains(act['category']) then
		abil_ID = act['param']
		effect_val = act['targets'][1]['actions'][1]['param']
	end
	
	if act['category'] == 2 then
		spell.english = 'Ranged Attack'
	else
		if not dialog[msg_ID] then
			if T{4,8}:contains(act['category']) then
				spell = r_spells[abil_ID]
			elseif T{3,6,7,13,14,15}:contains(act['category']) then
				spell = r_abilities[abil_ID] -- May have to correct for charmed pets some day, but I'm not sure there are any monsters with TP moves that give no message.
			elseif T{5,9}:contains(act['category']) then
				spell = r_items[abil_ID]
			else
				spell = {none=tostring(msg_ID)} -- Debugging
			end
			return spell
		end
		
		
		local fields = fieldsearch(dialog[msg_ID][language])
		
		if table.contains(fields,'spell') then
			spell = r_spells[abil_ID]
		elseif table.contains(fields,'ability') then
			spell = r_abilities[abil_ID]
		elseif table.contains(fields,'weapon_skill') then
--			if abil_ID > 255 then -- WZ_RECOVER_ALL is used by chests in Limbus
--				spell = r_mabils[abil_ID-256]
--				if spell.english == '.' then
--					spell.english = 'Special Attack'
--				end
--			elseif abil_ID < 256 then
				spell = r_abilities[abil_ID+768]
--			end
		elseif msg_ID == 303 then
			spell = r_abilities[74] -- Divine Seal
		elseif msg_ID == 304 then
			spell = r_abilities[75] -- 'Elemental Seal'
		elseif msg_ID == 305 then
			spell = r_abilities[76] -- 'Trick Attack'
		elseif msg_ID == 311 or msg_ID == 311 then
			spell = r_abilities[79] -- 'Cover'
		elseif msg_ID == 240 or msg_ID == 241 then
			spell = r_abilities[43] -- 'Hide'
		end
		
		
		if table.contains(fields,'item') then
			spell = r_items[abil_ID]
		else
			spell = aftercast_cost(spell)
		end
	end
	
	spell.name = spell[language]
	return spell
end

function aftercast_cost(rline)
	if rline == nil then
		return {tpaftercast = player['tp'],mpaftercast = tonumber(player['mp']),mppaftercast = tonumber(player['mpp'])}
	end
	if not rline['mpcost'] then rline['mpcost'] = 0 end
	if not rline['tpcost'] then rline['tpcost'] = 0 end
	
	if tonumber(rline['tpcost']) == 0 or not rline['tpcost'] then rline['tpaftercast'] = player['tp'] else
	rline['tpaftercast'] = player['tp'] - tonumber(rline['tpcost']) end
	
	if tonumber(rline['mpcost']) == 0 then
		rline['mpaftercast'] = tonumber(player['mp'])
		rline['mppaftercast'] = tonumber(player['mpp'])
	else
		rline['mpaftercast'] = player['mp'] - tonumber(rline['mpcost'])
		rline['mppaftercast'] = (player['mp'] - tonumber(rline['mpcost']))/player['max_mp']
	end
	
	return rline
end

function get_action_type(category)
	local action_type
	if category == 3 and not midaction then -- Try to filter for Job Abilities that come back as WSs.
		action_type = 'Job Ability'
	else
		action_type = category_map[category]
	end
	return action_type
end