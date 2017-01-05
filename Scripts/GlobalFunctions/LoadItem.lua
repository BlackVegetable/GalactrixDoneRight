

local function LoadItem(itemCode,item)
	if not item then
		item = GameObjectManager:Construct("Item")
	end
	item:SetAttribute('name', string.format("[%s_NAME]", itemCode))
	item:SetAttribute('description', string.format("[%s_DESC]", itemCode))
	item:SetAttribute('icon',ITEMS[itemCode].icon)
	item:SetAttribute('engine_requirement', ITEMS[itemCode].engine_requirement)
	item:SetAttribute('weapon_requirement',ITEMS[itemCode].weapon_requirement)
	item:SetAttribute('cpu_requirement', ITEMS[itemCode].cpu_requirement)
	--item:SetAttribute('shield_requirement', ITEMS[itemCode].shield_requirement)
	--item:SetAttribute('lvl_requirement', ITEMS[itemCode].lvl_requirement)
	item:SetAttribute('cost', ITEMS[itemCode].cost)
	item:SetAttribute('rarity', ITEMS[itemCode].rarity)
	item:SetAttribute('recharge', ITEMS[itemCode].recharge)
	item:SetAttribute('status_on_enemy', ITEMS[itemCode].status_on_enemy)
	item:SetAttribute('psi_requirement', ITEMS[itemCode].psi_requirement)
	item:SetAttribute('user_input', ITEMS[itemCode].user_input)--requires game object to be selected by user.
	item:SetAttribute('end_turn', ITEMS[itemCode].end_turn)
	item:SetAttribute('passive', ITEMS[itemCode].passive)


	item:SetAttribute('activation_sound', ITEMS[itemCode].activation_sound)
	--item:SetAttribute('recharged_sound', ITEMS[itemCode].recharge_sound)


	--item:SetAttribute('power_rating', ITEMS[itemCode].power_rating)


	item.classIDStr = itemCode


	if ITEMS[itemCode].Activate then
		item.Activate = ITEMS[itemCode].Activate
	end

	if ITEMS[itemCode].ValidInput then
		item.ValidInput = ITEMS[itemCode].ValidInput
	end

	if ITEMS[itemCode].ShouldAIUseItem then
		item.ShouldAIUseItem = ITEMS[itemCode].ShouldAIUseItem
	end

	if ITEMS[itemCode].GetAIUserInput then
		item.GetAIUserInput = ITEMS[itemCode].GetAIUserInput
	end

	return item
end

return LoadItem
