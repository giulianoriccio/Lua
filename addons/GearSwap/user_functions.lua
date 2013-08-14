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


-- Functions that are directly exposed to users --


function debug_mode(boolean)
	if boolean == true or boolean == false then _global.debug_mode = boolean
	elseif boolean == nil then
		_global.debug_mode = true
	else
		add_to_chat(123,'GearSwap: debug_mode was passed an invalid value')
	end
end


function show_swaps(boolean)
	if boolean == true or boolean == false then _global.show_swaps = boolean
	elseif boolean == nil then
		_global.show_swaps = true
	else
		add_to_chat(123,'GearSwap: show_swaps was passed an invalid value')
	end
end


function verify_equip(boolean)
	if boolean == true or boolean == false then _global.verify_equip = boolean
	elseif boolean == nil then
		_global.verify_equip = true
	else
		add_to_chat(123,'GearSwap: verify_equip was passed an invalid value')
	end
end


function cancel_spell(boolean)
	if boolean == true or boolean == false then _global.cancel_spell = boolean
	elseif boolean == nil then
		_global.cancel_spell = true
	else
		add_to_chat(123,'GearSwap: cancel_spell was passed an invalid value')
	end
end

function force_send(boolean)
	if boolean == true or boolean == false then _global.force_send = boolean
	elseif boolean == nil then
		_global.force_send = true
	else
		add_to_chat(123,'GearSwap: force_send was passed an invalid value')
	end
end

function change_target(name)
	if name and type(name)=='string' then _global.storedtarget = name else
		add_to_chat(123,'GearSwap: change_target was passed an invalid value')
	end
end

function cast_delay(delay)
	if tonumber(delay) then
		_global.cast_delay = tonumber(delay)
	else
		add_to_chat(123,'GearSwap: Cast delay is not a number')
	end
end

function set_combine(set1,set2)
	if set1 == nil then add_to_chat(123,'GearSwap: set_combine error, Set 1 is nil') end
	if set2 == nil then add_to_chat(123,'GearSwap: set_combine error, Set 2 is nil') end
	local set3 = {}
	for i,v in pairs(set1) do
		if slot_map[i] then
			set3[default_slot_map[slot_map[i]]] = v
		else
			add_to_chat(123,'GearSwap: set_combine error, Set 1 contains an unrecognized slot name ('..i..')')
		end
	end
	for i,v in pairs(set2) do
		if slot_map[i] then
			set3[default_slot_map[slot_map[i]]] = v
		else
			add_to_chat(123,'Gearswap: set_combine error, Set 2 contains an unrecognized slot name ('..i..')')
		end
	end
	return set3
end

function equip(...)
	local gearsets = {...}
	for i in ipairs(gearsets) do
		local temp_set = unify_slots(gearsets[i])
		for n,m in pairs(temp_set) do
			rawset(equip_list,n,m)
		end
	end
end

function print_set(set,title)
	if title then
		add_to_chat(1,'------------------------- '..title..' -------------------------')
	else
		add_to_chat(1,'----------------------------------------------------------------')
	end
	for i,v in pairs(set) do
		add_to_chat(8,tostring(i)..' '..tostring(v))
	end
	add_to_chat(1,'----------------------------------------------------------------')
end

function send_cmd_user(command)
	if string.byte(1) ~= 0x40 then
		command='@'..command
	end
	send_command(command)
end