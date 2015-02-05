
-- Pttn
--  
--

-- import our base class
local Pattern = import("Patterns/Pattern")

class "Pttn" (Pattern)


Pttn.AttributeDescriptions = AttributeDescriptionList(Pattern.AttributeDescriptions)

function Pttn:__init()
    super("Pttn")
    
end


return ExportClass("Pttn")
