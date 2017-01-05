-- SpawnGems
--  this event is sent from the battleground to itself
--  it causes the gems to be spawned

use_safeglobals()






class "Update" (GameEvent)

Update.AttributeDescriptions = AttributeDescriptionList()


function Update:__init()
    super("Update")
	LOG(string.format("%s  - UpdateEvent__init(%s)",tostring(_G.SCREENS.GameMenu.world.my_player_id),tostring(_G.SCREENS.GameMenu.world.state)))
end

return ExportClass("Update")
