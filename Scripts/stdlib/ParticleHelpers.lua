
use_safeglobals()

--[[
Helper functions for attaching particle systems to game objects without handling the system it

--]]

function _G.AttachParticles(obj, system, x, y)
    -- defaults
    x = x or 0
    y = y or 0

    if  obj and
        type(system) == "string" and
        type(x) == "number" and
        type(y) == "number"
    then
		-- remove with obj:DeleteParticles(psys)
        local psys = ParticleRenderer:CreateParticleSystem(string.format("Assets/Particles/%s.xml",system))
        obj:AddParticlesPos(psys, x, y)
		--LOG("Added particles " .. system .. " at " .. x .. ", " .. y)
		return psys
    end
end

