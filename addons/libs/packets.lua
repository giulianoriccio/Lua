--[[
A list of deciphered packets and their meaning, with a short description.
When size is 0x00 it means the size is either unknown or varies.
]]

_libs = _libs or {}
_libs.packets = true
_libs.lists = _libs.lists or require 'lists'

local packets = {}
packets.incoming = {}
packets.outgoing = {}

--[[
	Packet database. Feel free to correct/amend it wherever it's lacking.
]]

-- Client packets
packets.outgoing[0x00A] = {name='Client Connect',      size=0x2E, description='(unencrypted/uncompressed) First packet sent when connecting to new zone.'}
packets.outgoing[0x00D] = {name='Client Leave',        size=0x04, description='Last packet sent from client before it leaves the zone.'}
packets.outgoing[0x015] = {name='Standard Client',     size=0x10, description='Packet contains data that is sent almost every time (i.e your character\'s position).'}
packets.outgoing[0x01A] = {name='Action',              size=0x08, description='An action being done on a target (i.e. an attack or spell).'}
packets.outgoing[0x028] = {name='Drop Item',           size=0x06, description='Drops an item.'}
packets.outgoing[0x029] = {name='Move Item',           size=0x06, description='Move item from one inventory to another.'}
packets.outgoing[0x032] = {name='Offer Trade',         size=0x06, description='This is sent when you offer to trade somebody.'}
packets.outgoing[0x033] = {name='Trade Tell',          size=0x06, description='This packet allows you to accept or cancel a trade request.'}
packets.outgoing[0x034] = {name='Trade Item',          size=0x06, description='Sends the item you want to trade to the server.'}
packets.outgoing[0x037] = {name='Use Item',            size=0x0A, description='Use an item.'}
packets.outgoing[0x03A] = {name='Sort Item',           size=0x04, description='Packet sent when you choose to auto-sort your inventory.'}
packets.outgoing[0x04B] = {name='Servmes',             size=0x0C, description='Requests the server message (/servmes).'}
packets.outgoing[0x04E] = {name='Auction',             size=0x1E, description='Used to bid on an Auction House item.'}
packets.outgoing[0x050] = {name='Equip',               size=0x04, description='This command is used to equip your character.'}
packets.outgoing[0x05A] = {name='Conquest',            size=0x02, description='This command asks the server for data pertaining to conquest/besieged status.'}
packets.outgoing[0x05B] = {name='Set Home Point',      size=0x0A, description='Set your home point.'}
packets.outgoing[0x05D] = {name='Emote',               size=0x08, description='This command is used in emotes.'}
packets.outgoing[0x05E] = {name='Reqest Zone',         size=0x0C, description='Request from the client to zone.'}
packets.outgoing[0x061] = {name='Equipment Screen',    size=0x02, description='This command is used when you open your equipment screen.'}
packets.outgoing[0x06E] = {name='Invite Player',       size=0x06, description='Used for Inviting.'}
packets.outgoing[0x083] = {name='Buy Item',            size=0x08, description='Buy an item.'}
packets.outgoing[0x084] = {name='Appraise',            size=0x06, description='Ask server for selling price.'}
packets.outgoing[0x085] = {name='Sell Item',           size=0x04, description='Sell an item from your inventory.'}
packets.outgoing[0x096] = {name='Synth',               size=0x12, description='Packet sent containing all data of an attempted synth.'}
packets.outgoing[0x0B5] = {name='Speech',              size=0x00, description='Packet contains normal speech.'}
packets.outgoing[0x0B6] = {name='Tell',                size=0x00, description='/tell\'s sent from client.'}
packets.outgoing[0x0DC] = {name='Type Bitmask',        size=0x0A, description='This command is sent when change your party-seek or /anon status.'}
packets.outgoing[0x0DD] = {name='Check',               size=0x06, description='Used to check other players.'}
packets.outgoing[0x0DE] = {name='Set Bazaar Message',  size=0x40, description='Sets your bazaar message.'}
packets.outgoing[0x0E7] = {name='Logout',              size=0x04, description='A request to logout of the server.'}
packets.outgoing[0x0E8] = {name='Toggle Heal',         size=0x04, description='This command is used to both heal and cancel healing.'}
packets.outgoing[0x0F4] = {name='Widescan',            size=0x04, description='This command asks the server for a widescan.'}
packets.outgoing[0x100] = {name='Job Change',          size=0x04, description='Sent when initiating a job change.'}
packets.outgoing[0x104] = {name='Leave Bazaar',        size=0x02, description='Sent when client leaves a bazaar.'}
packets.outgoing[0x105] = {name='View Bazaar',         size=0x06, description='Sent when viewing somebody\'s bazaar.'}
packets.outgoing[0x106] = {name='Buy Bazaar Item',     size=0x06, description='Buy an item from somebody\'s bazaar.'}
packets.outgoing[0x10A] = {name='Set Price',           size=0x06, description='Set the price on a bazaar item.'}

-- Server packets
packets.incoming[0x009] = {name='Standard Message',    size=0x08, description='A standardized message send from FFXI.'}
packets.incoming[0x00A] = {name='Data Download 1',     size=0x82, description='Info about character and zone around it.'}
packets.incoming[0x00B] = {name='Zone Response',       size=0x0E, description='Response from the server confirming client can zone.'}
packets.incoming[0x00D] = {name='PC Update',           size=0x2E, description='Packet contains info about another PC (i.e. coordinates).'}
packets.incoming[0x00E] = {name='NPC Update',          size=0x00, description='Packet contains data about nearby targets (i.e. target\'s position, name).'}
packets.incoming[0x017] = {name='Incoming Chat',       size=0x00, description='Packet contains data about incoming chat messages.'}
packets.incoming[0x01B] = {name='Job Info',            size=0x32, description='Job Levels and levels unlocked.'}
packets.incoming[0x01C] = {name='Inventory Count',     size=0x0A, description='Describes number of slots in inventory.'}
packets.incoming[0x01D] = {name='Finish Inventory',    size=0x04, description='Finish listing the items in inventory.'}
packets.incoming[0x01E] = {name='Modify Inventory',    size=0x08, description='Modifies items in your inventor.'}
packets.incoming[0x01F] = {name='Item Assign',         size=0x08, description='Assigns an ID to equipped items in your inventory.'}
packets.incoming[0x020] = {name='Item Update',         size=0x16, description='Info about item in your inventory.'}
packets.incoming[0x021] = {name='Trade Requested',     size=0x06, description='Sent when somebody offers to trade with you.'}
packets.incoming[0x022] = {name='Trade Action',        size=0x08, description='Sent whenever something happens with the trade window.'}
packets.incoming[0x025] = {name='Item Accepted',       size=0x06, description='Sent when the server will allow you to trade an item.'}
packets.incoming[0x028] = {name='Action',              size=0x12, description='Packet sent when an NPC is attacking.'}
packets.incoming[0x029] = {name='EXP Gain',            size=0x0E, description='Packet sent after you defeat a mob and do not gain XP.'}
packets.incoming[0x02D] = {name='EXP Gain (kill)',     size=0x0E, description='Packet sent after you defeat a mob and gain XP.'}
packets.incoming[0x036] = {name='NPC Chat',            size=0x08, description='Dialog from NPC\'s.'}
packets.incoming[0x037] = {name='Update Char',         size=0x28, description='Updates a characters stats and animation.'}
packets.incoming[0x03C] = {name='Shop',                size=0x00, description='Displays items in a vendors shop.'}
packets.incoming[0x03D] = {name='Value',               size=0x08, description='Returns the value of an item.'}
packets.incoming[0x041] = {name='Stupid Evil Packet',  size=0x7C, description='This packet is stupid and evil. Required for emotes.'}
packets.incoming[0x04B] = {name='Logout Acknowledge',  size=0x0A, description='Acknoledges a logout attempt.'}
packets.incoming[0x04B] = {name='Delivery Item',       size=0x2C, description='Item in delivery box.'}
packets.incoming[0x04D] = {name='Servmes Resp',        size=0x0E, description='Server response when someone requests it.'}
packets.incoming[0x04F] = {name='Data Download 2',     size=0x04, description='The data that is sent to the client when it is "Downloading data...".'}
packets.incoming[0x050] = {name='Equip',               size=0x04, description='Updates the characters equipment slots.'}
packets.incoming[0x051] = {name='Data Download 3',     size=0x0C, description='Info about equipment and appearance.'}
packets.incoming[0x052] = {name='NPC Release',         size=0x04, description='Allows your PC to move after interacting with an NPC.'}
packets.incoming[0x053] = {name='Logout Time',         size=0x08, description='The annoying message that tells how much time till you logout.'}
packets.incoming[0x058] = {name='Lock Target',         size=0x08, description='Locks your target.'}
packets.incoming[0x05A] = {name='Server Emote',        size=0x0C, description='This packet is the server\'s response to a client /emote p.'}
packets.incoming[0x05B] = {name='Spawn',               size=0x0E, description='Server packet sent when a new mob spawns in area.'}
packets.incoming[0x05E] = {name='Stop Download',       size=0x5A, description='Final packet in a DataDld transmission. May be the only packet in a DataDld sequence.'}
packets.incoming[0x061] = {name='Char Stats',          size=0x2A, description='Packet contains a lot of data about your character\'s stats.'}
packets.incoming[0x062] = {name='Skills Update',       size=0x80, description='Packet that shows your weapon and magic skill stats.'}
packets.incoming[0x0B4] = {name='Seek AnonResp',       size=0x0C, description='Server response sent after you put up party or anon flag.'}
packets.incoming[0x0C9] = {name='Show Equip',          size=0x4C, description='Shows another player your equipment after using the Check command.'}
packets.incoming[0x0CC] = {name='Linkshell Message',   size=0x58, description='/lsmes text and headers.'}
packets.incoming[0x0CA] = {name='Show Bazaar Message', size=0x4A, description='Shows another players bazaar message after using the Check command.'}
packets.incoming[0x0D2] = {name='Found Item',          size=0x1E, description='This command shows an item found on defeated mob.'}
packets.incoming[0x0DD] = {name='Alliance Update',     size=0x16, description='Alliance/party member info - zone, HP%, HP% etc.'}
packets.incoming[0x0DF] = {name='Char Update',         size=0x0E, description='A packet sent from server which updates character HP, MP and TP.'}
packets.incoming[0x0E2] = {name='Char Info',           size=0x18, description='Sends name, HP, HP%, etc.'}
packets.incoming[0x0F4] = {name='Widescan Mob',        size=0x0E, description='Displays one monster.'}
packets.incoming[0x0F6] = {name='Widescan Mark',       size=0x04, description='Marks the start and ending of a widescan list.'}
packets.incoming[0x105] = {name='Data Download 4',     size=0x16, description='The data that is sent to the client when it is "Downloading data...".'}
packets.incoming[0x108] = {name='Data Download 5',     size=0x00, description='The data that is sent to the client when it is "Downloading data...".'}

-- C type information
local function make_val(ctype, ...)
	if ctype == 'unsigned int' or ctype == 'unsigned short' or ctype == 'unsigned char' or ctype == 'unsigned long' then
		return tonumber(L{...}:reverse():map(string.zfill-{2}..math.tohex):concat(), 16)
	else
		return data
	end
end

local lengths = {}
lengths['bool'] = 1
lengths['unsigned char'] = 1
lengths['unsigned short'] = 2
lengths['unsigned int'] = 4
lengths['unsigned long'] = 8
lengths['signed char'] = 1
lengths['signed short'] = 2
lengths['signed int'] = 4
lengths['signed long'] = 8
lengths['char'] = 1
lengths['short'] = 2
lengths['int'] = 4
lengths['long'] = 8
lengths['float'] = 4
lengths['double'] = 8

-- Specific field data for p.
local fields = {}
fields.incoming = {}
fields.outgoing = {}

fields.incoming[0x0DF] = L{
	{ctype='unsigned int', field='id'}, -- 4-7
	{ctype='unsigned int', field='hp'}, -- 8-11
	{ctype='unsigned int', field='mp'}, -- 12-15
	{ctype='unsigned int', field='tp'}, -- 16-19
	{ctype='unsigned short', field='_unknown_20_21'},
	{ctype='unsigned short', field='_unknown_22_23'},
	{ctype='unsigned short', field='_unknown_24_25'},
	{ctype='unsigned short', field='_unknown_26_27'}
}

function Pin(id, data)
	return P(id, data, 'incoming')
end

function Pout(id, data)
	return P(id, data, 'outgoing')
end

function P(id, data, mode)
	local res = {}
	res._id = id
	res._size = 2*math.floor(data:byte(2)/2)
	res._raw = data
	res._seq = data:byte(3,3) + data:byte(4, 4)*2^8
	res._data = data:sub(5)
	res._hex = data:sub(5):map(string.zfill-{2}..math.tohex..string.byte)

	if not fields[mode][id] then
		return res
	end

	local temp
	local val
	local pos = 5
	for pt in fields[mode][id]:it() do
		temp = pos
		pos = pos + lengths[pt.ctype]
		res[pt.field] = make_val(pt.ctype, data:byte(temp, pos - 1))
	end

	return res
end

return setmetatable(packets, {index={name='Unknown', size=0x00, description='No data available.'}}), fields
