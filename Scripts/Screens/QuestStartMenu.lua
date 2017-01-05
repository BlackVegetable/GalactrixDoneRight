use_safeglobals()


-- declare our menu
class "QuestStartMenu" (Menu);

local mode = ""

function QuestStartMenu:__init()
	super()
	
	-- load the xml spec for the screen. this causes widgets to be added and anims to be parsed and added
	self:Initialize("Assets\\Screens\\QuestStartMenu.xml")

end

function QuestStartMenu:OnButton(buttonId, clickX, clickY)
	
	if (buttonId == 0) then
		--accept
		
		if #GetRunningQuests(_G.Hero) == 4 then
			open_message_menu("[CANT_ACCEPT]", "[TOO_MANY_QUESTS]")
		else
			
			local function AcceptQuest()	
				--Graphics.FadeFromBlack()
				_G.Hero:SetToSave()	
				_G.StartQuest(_G.Hero, self.quest)
			end
			
			local function CloseQuestStartMenu()				
				_G.CallScreenSequencer("QuestStartMenu", AcceptQuest)
			end
			--Graphics.FadeToBlack()
			_G.CallScreenSequencer("GetQuestsMenu",CloseQuestStartMenu)
		
			
		end
	elseif (buttonId == 1) then
		--decline
		
		self:Close()
	end



	return Menu.MESSAGE_HANDLED
end

----------------------------------------------------------------------
-- SetSource(src)
--
-- Sets the source or parent menu (ie: since this is a dialog, the 
-- source should be the menu that sits behind it)
-- Param: src - The Parent Menu
----------------------------------------------------------------------
function QuestStartMenu:SetSource(src)
	self.src = src
end

function QuestStartMenu:SetQuest(quest)
	self.quest = quest
	
	self:set_text("str_heading", string.format("[%s_TITLE]", quest))
	self:set_text("str_message", string.format("[%s_DESC]", quest))
	
	local function DS_LanguageResize()
		if get_text_length("font_heading", translate_text(string.format("[%s_TITLE]", quest))) < 180 then
			self:set_text("str_heading", string.format("[%s_TITLE]", quest))
			self:hide_widget("str_heading2")
		else
			self:set_text("str_heading2", string.format("[%s_TITLE]", quest))
			self:hide_widget("str_heading")
		end
	end
	
	_G.DSOnly(DS_LanguageResize)
	
end


-- return an instance of QuestStartMenu
return ExportSingleInstance("QuestStartMenu")
