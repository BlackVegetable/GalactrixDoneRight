
function InputValidate(value)
    value = value or "none"

    print("Validated Input: " .. value)
    return true;
end

function InputSelect(value)
    value = value or "none"
	LOG("Gamepad active = " .. tostring(IsGamepadActive()))
	 
	SetIsGamepadActive(value == 1)
	--SetIsMouseActive(not (value == 1))
	 
    print("Selected Input: " .. value)
    return true;
end

AddOption("input", InputValidate, InputSelect, { ["[INPUT0]"] = 0, ["[INPUT1]"] = 1 }, Settings:Read("input", 0))
