-- ClearNetworkHero 
--When Players change Hero to use in MP
--This is sent to server to replicate outward.

use_safeglobals()






class "ClearNetworkHero" (GameEvent)

ClearNetworkHero.AttributeDescriptions = AttributeDescriptionList()

ClearNetworkHero.AttributeDescriptions:AddAttributeCollection('GameObject', 'hero', {serialize= 1})
ClearNetworkHero.AttributeDescriptions:AddAttributeCollection('GameObject', 'ship', {serialize= 1})
ClearNetworkHero.AttributeDescriptions:AddAttributeCollection('GameObject', 'loadout', {serialize= 1})




function ClearNetworkHero:__init()
    super("ClearNetworkHero")
    LOG("ClearNetworkHero Init()")
	self:SetSendToSelf(false)
end



function ClearNetworkHero:do_OnReceive()
	LOG("ClearNetworkHero OnReceive() "..tostring(SCREENS.MultiplayerGameSetup.my_id))
	--and add an entry to the log
	
	for i=1, self:NumAttributes("hero") do
		LOG("hero loop")
		local hero = self:GetAttributeAt("hero",i)
		self:EraseAttribute("hero", hero)
		if hero then
			LOG("Destroy Hero")
			GameObjectManager:Destroy(hero)
		end
		hero = nil
	end	
	for i=1, self:NumAttributes("ship") do
		LOG("ship loop")
		local ship = self:GetAttributeAt("ship",i)
		self:EraseAttribute("ship", ship)
		if ship then
			LOG("Destroy Ship")
			GameObjectManager:Destroy(ship)
		end
		ship=nil
	end
	
	for i=1, self:NumAttributes("loadout") do
		LOG("loadout loop")
		local loadout = self:GetAttributeAt("loadout",1)
		self:EraseAttribute("loadout", loadout)
		GameObjectManager:Destroy(loadout)
		loadout = nil
	end
	
	
end



return ExportClass("ClearNetworkHero")
