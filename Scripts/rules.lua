-- Rules
--	This is a conveniant place to put formulae that the game mechanics rely on

use_safeglobals()





_G.RULES = {}


function RULES.GetSkillCap(character, skill)
	return 20;
end
function RULES.GetSkillCost(hero, skill)
	return 1000;
end
function RULES.CanTrain(hero, skill)
	return true;
end




-- Calculate in battle stat maximums from ship stats
function RULES.CalcMaxHull(hullRank)
	return 50 + 10*hullRank;
end
function RULES.CalcMaxShield(shieldRank)
	return 10 * shieldRank
end
function RULES.CalcMaxEnergy(engineRank)
	return 5 + engineRank;
end


