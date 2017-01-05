
function TutorialValidate(value)
    value = value or "none"

    print("Validated Tutorial: " .. value)
    return true;
end

function TutorialSelect(value)
    value = value or 0
	_G.SHOW_TUTORIALS = value
	if _G.Hero then
		_G.SetShowingTutorials(_G.Hero, value)
	end
    print("Selected Tutorial: " .. value)
    return true;
end


AddOption("tutorial", TutorialValidate, TutorialSelect, { ["[NO]"] = 1, ["[YES]"] = 2 },  _G.SHOW_TUTORIALS)
