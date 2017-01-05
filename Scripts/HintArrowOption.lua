
function HintArrowValidate(value)
    value = value or "none"

    LOG("Validated HintArrow: " .. value)
    return true;
end

function HintArrowSelect(value)
    value = value or "none"

   LOG("Selected HintArrow: " .. value)
    return true;
end

LOG("Add hint_arrow Option")
AddOption("hint_arrow", HintArrowValidate, HintArrowSelect, { ["[NONE]"] = 0, ["[10]"] = 10, ["[30]"] = 30, ["[60]"] = 60 }, Settings:Read('hint_arrow', 10))
