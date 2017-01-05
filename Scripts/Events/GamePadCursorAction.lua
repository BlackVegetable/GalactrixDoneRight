
class "GamePadCursorAction" (GameEvent)

GamePadCursorAction.AttributeDescriptions = AttributeDescriptionList()
GamePadCursorAction.AttributeDescriptions:AddAttribute('GameObject', "object", {})
GamePadCursorAction.AttributeDescriptions:AddAttribute('int', "x", {default=0})
GamePadCursorAction.AttributeDescriptions:AddAttribute('int', "y", {default=0})
GamePadCursorAction.AttributeDescriptions:AddAttribute('int', "up", {default=0})
GamePadCursorAction.AttributeDescriptions:AddAttribute('int', "user", {default=0})

function GamePadCursorAction:__init()
    super("GamePadCursorAction")
end

return ExportClass("GamePadCursorAction")
